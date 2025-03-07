{
  pkgs,
  config,
  ...
}:

let
  commit = "ac0e8f0f32e3de145dc3aa11d8182f208a05397f";
  pversion = "1.98.0-insider-${commit}";
  isDarwin = pkgs.stdenv.isDarwin;
  sha256 =
    if isDarwin then
      "sha256-i/tBF5BbkJKfbGbddFs+ssbcJijSoO6xsmd98RSmxas="
    else
      "sha256-mBbuD6acI5mOseHhSnlGdidwf//OikEBYnHT5MCNK9o=";
  os = if isDarwin then "darwin-arm64" else "linux-x64";
  archive = if isDarwin then "zip" else "tar.gz";
  pname = "VSCODE_insiders_${os}_${pversion}.${archive}";
  url = "https://code.visualstudio.com/sha/download?build=insider&os=${os}";
  custom-ui-style = pkgs.vscode-marketplace.subframe7536.custom-ui-style;
  vscodeAppRoot =
    if isDarwin then
      "/Applications/Visual\ Studio\ Code\ -\ Insiders.app/Contents/Resources/app"
    else
      "";
  vscode-insiders =
    (pkgs.vscode.override {
      isInsiders = true;
      useVSCodeRipgrep = isDarwin;
    }).overrideAttrs
      (previousAttrs: {
        pname = "vscode-insiders";
        version = pversion;
        meta.mainProgram = "code-insiders";
        src = (
          pkgs.fetchurl {
            inherit sha256 url;
            name = pname;
          }
        );
        buildInputs = previousAttrs.buildInputs ++ [
          pkgs.bun
        ];
        postInstall = ''
          # Add post-installation steps here
          cd $out
          mkdir -p custom-ui-style
          cp -r ${custom-ui-style}/share/vscode/extensions/subframe7536.custom-ui-style/ custom-ui-style/
          chmod -R u+w custom-ui-style/subframe7536.custom-ui-style/
          cd custom-ui-style/subframe7536.custom-ui-style/
          # Remove everything from the logger.ts file
          rm -f src/logger.ts
          touch src/logger.ts
          tee -a src/logger.ts <<EOF
            export const log = {
             info: console.info.bind(console),
             warn: console.warn.bind(console),
             error: console.error.bind(console),
             append: console.log.bind(console),
             appendLine: console.log.bind(console),
             replace: console.log.bind(console),
             clear: console.clear.bind(console),
             show: console.log.bind(console),
             hide: console.log.bind(console),
            };
          EOF

          # Replace the line 17 in the utils.ts file
          sed -i '17c\
          const lockFile = path.join("__" + Meta.name + "__.lock")' src/utils.ts

          touch src/install.ts
          tee -a src/install.ts <<EOF
            import fs from 'node:fs'
            import { readFileSync, writeFileSync } from 'atomically'
            import { type FileManager, BaseFileManager } from './manager/base'
            import { CssFileManager } from './manager/css'
            import { ExternalFileManager } from './manager/external'
            import { JsonFileManager } from './manager/json'
            import { MainFileManager } from './manager/main'
            import { RendererFileManager } from './manager/renderer'
            import { WebViewFileManager } from './manager/webview'


            async function reload(manager: BaseFileManager) {
              if (!manager.hasBakFile) {
                console.warn('Backup file does not exist, backuping...', manager.bakPath)
                fs.cpSync(manager.srcPath, manager.bakPath)
                console.info('Create backup file', manager.bakPath)
              }
              const newContent = await manager.patch(readFileSync(manager.bakPath, 'utf-8'))
              writeFileSync(manager.srcPath, newContent)
              console.info('Config reload', manager.srcPath)
            }

            async function pathAll() {
              const managers: FileManager[] = [
                new CssFileManager(),
                new MainFileManager(),
                new RendererFileManager(),
                new ExternalFileManager(),
                new WebViewFileManager(),
                new JsonFileManager(), // MUST be the end of managers
              ];
              for (const manager of managers) {
                try {
                  await reload(manager);
                } catch (e) {
                  console.error(e);
                }
              }
            }
            await pathAll();
          EOF
          cat src/install.ts
          bun install
          # Create a stub vscode package.
          mkdir -p node_modules/vscode
          echo '{"name":"vscode","version":"1.0.0","main":"index.js"}' > node_modules/vscode/package.json
          touch node_modules/vscode/index.js
          tee node_modules/vscode/index.js <<EOF
            import * as url from 'node:url'
            export const commands = {};
            export const window = {};
            export const languages = {};
            export const workspace = {
               getConfiguration: (key) => ({ get: () => {}, update: () => {} }),
            };
            export const comments = {};
            export const debug = {};
            export const tasks = {};
            export const extensions = {};
            export const EventEmitter = class {};
            export const ColorThemeKind = {};
            export const Uri = url.Url;
            export const l10n = {};
            export const env = {
              appRoot: "$out" + "${vscodeAppRoot}",
              appHost: "desktop",
            };
            export const version = "${pversion}";
          EOF
          bun src/install.ts
          cd $out
        '';
      });
  package = if isDarwin then vscode-insiders else vscode-insiders.fhs;
  fontSize = if isDarwin then 20 else 16;
  zoomLevel = if isDarwin then 1 else 0;
in
rec {
  home.activation.makeVSCodeConfigWritable =
    let
      configDirName =
        {
          "vscode" = "Code";
          "vscode-insiders" = "Code - Insiders";
          "vscodium" = "VSCodium";
        }
        .${programs.vscode.package.pname};
      configPath =
        if isDarwin then
          "${config.home.homeDirectory}/Library/Application Support/${configDirName}/User/settings.json"
        else
          "${config.xdg.configHome}/${configDirName}/User/settings.json";
    in
    {
      after = [ "writeBoundary" ];
      before = [ ];
      data = ''
        echo "Making VSCode config writable: '${configPath}'"
        install -m 0640 "$(readlink '${configPath}')" '${configPath}'
      '';
    };
  programs.vscode = {
    enable = true;
    package = package;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    userSettings = {
      # Disable telemetry
      "telemetry.telemetryLevel" = "off";
      "editor.fontFamily" = "'JetBrainsMono Nerd Font', Menlo, Monaco, 'Courier New', monospace";
      "terminal.integrated.fontLigatures.enabled" = true;
      "window.zoomLevel" = zoomLevel;
      "editor.parameterHints.cycle" = true;
      "editor.letterSpacing" = 0.5;
      "editor.fontWeight" = "500";
      "editor.fontLigatures" = true;
      "editor.smoothScrolling" = true;
      "editor.formatOnPaste" = true;
      "editor.fastScrollSensitivity" = 2;
      "terminal.integrated.confirmOnExit" = "hasChildProcesses";
      "terminal.integrated.cursorBlinking" = true;
      "editor.cursorWidth" = 5;
      "editor.cursorBlinking" = "solid";
      "explorer.openEditors.visible" = 1;
      "workbench.editor.showTabs" = "single";
      "workbench.commandPalette.preserveInput" = true;
      "editor.glyphMargin" = true;
      "files.exclude" = {
        "**/__pycache__" = true;
        "**/.dart_tool" = true;
        "**/.idea" = true;
        "**/*.g.dart" = true;
        "**/*.pyc" = true;
        "**/build" = true;
        "**/dist" = true;
        "**/target" = true;
        "**/.classpath" = true;
        "**/.project" = true;
        "**/.settings" = true;
        "**/.factorypath" = true;
      };
      "editor.renderWhitespace" = "boundary";
      "editor.renderControlCharacters" = false;
      "breadcrumbs.enabled" = false;
      "git.autofetch" = true;
      "git.enableSmartCommit" = true;
      "git.confirmSync" = false;
      "gitlens.currentLine.enabled" = false;
      "gitlens.currentLine.scrollable" = false;
      "gitlens.hovers.currentLine.over" = "line";
      "gitlens.blame.avatars" = false;
      "gitlens.hovers.enabled" = false;
      "typescript.updateImportsOnFileMove.enabled" = "always";
      "javascript.updateImportsOnFileMove.enabled" = "always";
      "editor.tabSize" = 2;
      "files.associations" = {
        "*.tera" = "html";
      };
      "editor.formatOnSave" = true;
      "files.watcherExclude" = {
        "**/build/**" = true;
        "**/node_modules/**" = true;
      };
      "editor.suggestSelection" = "first";
      "terminal.integrated.fontSize" = fontSize;
      "markdown.preview.lineHeight" = 1.2;
      "editor.accessibilityPageSize" = 5;
      "vsicons.presets.hideExplorerArrows" = true;
      "vsicons.presets.tsOfficial" = true;
      "editor.cursorSmoothCaretAnimation" = "on";
      "editor.quickSuggestionsDelay" = 5;
      "editor.suggest.localityBonus" = true;
      "debug.inlineValues" = "auto";
      "[dart]" = {
        "editor.formatOnSave" = true;
        "editor.formatOnType" = true;
        "editor.rulers" = [ 80 ];
        "editor.selectionHighlight" = false;
        "editor.suggest.snippetsPreventQuickSuggestions" = false;
        "editor.suggestSelection" = "first";
        "editor.tabCompletion" = "onlySnippets";
        "editor.wordBasedSuggestions" = "off";
      };
      "extensions.ignoreRecommendations" = true;
      "workbench.startupEditor" = "none";
      "editor.fontSize" = fontSize;
      "editor.inlineSuggest.enabled" = true;
      "editor.bracketPairColorization.enabled" = true;
      "editor.guides.bracketPairs" = true;
      "editor.tabCompletion" = "onlySnippets";
      "diffEditor.codeLens" = true;
      "editor.suggest.preview" = true;
      "search.useGlobalIgnoreFiles" = true;
      "debug.confirmOnExit" = "always";
      "extensions.autoUpdate" = false;
      "terminal.integrated.profiles.windows" = {
        "PowerShell" = {
          "source" = "PowerShell";
          "args" = [ "-NoLogo" ];
        };
      };
      "terminal.integrated.defaultProfile.windows" = "PowerShell";
      "terminal.integrated.tabs.title" = "\${local} \${process}";
      "terminal.external.windowsExec" = "pwsh.exe -NoLogo";
      "update.mode" = "start";
      "editor.lineNumbers" = "relative";
      "github.copilot.enable" = {
        "*" = true;
        "yaml" = true;
        "plaintext" = true;
        "markdown" = true;
      };
      "git.autoRepositoryDetection" = false;
      "git.enableCommitSigning" = true;
      "workbench.iconTheme" = "catppuccin-mocha";
      "workbench.productIconTheme" = "Default";
      "catppuccin.extraBordersEnabled" = true;
      "rust-analyzer.checkOnSave" = true;
      "rust-analyzer.check.command" = "clippy";
      "rust-analyzer.check.extraArgs" = [
        "--tests"
        "--"
        "-W"
        "clippy::complexity"
        "-W"
        "clippy::perf"
      ];
      "rust-analyzer.runnables.extraEnv" = {
        "SKIP_WASM_BUILD" = "1";
      };
      "rust-analyzer.cargo.extraEnv" = {
        "SKIP_WASM_BUILD" = "1";
      };
      "rust-analyzer.check.extraEnv" = {
        "SKIP_WASM_BUILD" = "1";
      };
      "rust-analyzer.completion.autoimport.enable" = true;
      "rust-analyzer.lens.enable" = true;
      "rust-analyzer.completion.postfix.enable" = true;
      "rust-analyzer.inlayHints.maxLength" = 3;
      "rust-analyzer.cargo.autoreload" = true;
      "rust-analyzer.imports.granularity.enforce" = true;
      "rust-analyzer.imports.granularity.group" = "module";
      "rust-analyzer.imports.group.enable" = true;
      "rust-analyzer.imports.prefix" = "crate";
      "rust-analyzer.completion.callable.snippets" = "add_parentheses";
      "rust-analyzer.inlayHints.renderColons" = false;
      "rust-analyzer.diagnostics.experimental.enable" = false;
      "rust-analyzer.inlayHints.typeHints.enable" = true;
      "errorLens.scrollbarHackEnabled" = true;
      "editor.semanticTokenColorCustomizations" = {
        "rules" = {
          "*.mutable" = {
            "fontStyle" = "underline";
          };
          "*.global" = "#cc881a";
          "*.static" = "#cc881a";
          "typeAlias" = "#aab01e";
          "function.unsafe" = "#f73028";
          "method.unsafe" = "#f73028";
        };
      };
      "remote.SSH.remotePlatform" = {
        "workstation" = "linux";
      };
      "workbench.colorTheme" = "Catppuccin Mocha";
      "files.insertFinalNewline" = true;
      "rust-analyzer.debug.openDebugPane" = true;
      "workbench.editor.limit.enabled" = true;
      "workbench.editor.limit.value" = 5;
      "workbench.editor.tabSizing" = "shrink";
      "[html]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "security.workspace.trust.untrustedFiles" = "newWindow";
      "[jsonc]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "terminal.external.osxExec" = "iTerm.app";
      "vsicons.dontShowNewVersionMessage" = true;
      "[typescript]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[javascript]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[handlebars]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[vue]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[python]" = {
        "editor.formatOnSave" = true;
        "editor.defaultFormatter" = "charliermarsh.ruff";
        "editor.codeActionsOnSave" = {
          "source.fixAll" = "explicit";
          "source.organizeImports" = "explicit";
        };
      };
      "ruff.nativeServer" = "on";
      "notebook.formatOnSave.enabled" = true;
      "dart.debugExternalPackageLibraries" = true;
      "dart.debugSdkLibraries" = false;
      "javascript.inlayHints.enumMemberValues.enabled" = true;
      "javascript.inlayHints.functionLikeReturnTypes.enabled" = true;
      "javascript.inlayHints.parameterNames.enabled" = "all";
      "javascript.inlayHints.parameterTypes.enabled" = true;
      "javascript.inlayHints.propertyDeclarationTypes.enabled" = true;
      "javascript.inlayHints.variableTypes.enabled" = true;
      "typescript.inlayHints.enumMemberValues.enabled" = true;
      "typescript.inlayHints.functionLikeReturnTypes.enabled" = true;
      "typescript.inlayHints.parameterNames.enabled" = "all";
      "typescript.inlayHints.parameterTypes.enabled" = true;
      "typescript.inlayHints.propertyDeclarationTypes.enabled" = true;
      "typescript.inlayHints.variableTypes.enabled" = true;
      "evenBetterToml.formatter.columnWidth" = 120;
      "[json]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "extensions.experimental.affinity" = {
        "asvetliakov.vscode-neovim" = 1;
      };
      "catppuccin.accentColor" = "teal";
      "vscode-neovim.logLevel" = "none";
      "lldb.suppressUpdateNotifications" = true;
      "terminal.integrated.defaultProfile.linux" = "zsh";
      "terminal.integrated.localEchoExcludePrograms" = [
        "vim"
        "vi"
        "nano"
        "tmux"
        "nvim"
      ];
      "terminal.integrated.gpuAcceleration" = "off";
      "sqltools.useNodeRuntime" = true;
      # Remove left-side icons
      "workbench.activityBar.location" = "hidden";
      # Remove bottom status bar
      "workbench.statusBar.visible" = true;
      # Remove position indicator in the editor's scrollbar
      "editor.hideCursorInOverviewRuler" = true;
      # Remove minimap
      "editor.minimap.enabled" = false;
      # Move tabs to be in a single line with window controls
      "window.titleBarStyle" = "custom";
      "window.menuBarVisibility" = "toggle";
      # Move sidebar to the right
      "workbench.sideBar.location" = "right";

      "github.copilot.editor.enableAutoCompletions" = true;
      "github.copilot.editor.enableCodeActions" = true;
      "chat.commandCenter.enabled" = true;
      "workbench.commandPalette.experimental.askChatLocation" = "quickChat";
      "github.copilot.chat.search.semanticTextResults" = true;
      "github.copilot.nextEditSuggestions.enabled" = true;
      "github.copilot.chat.editor.temporalContext.enabled" = true;
      "editor.inlineSuggest.edits.codeShifting" = true;
      "github.copilot.chat.generateTests.codeLens" = true;
      "github.copilot.chat.fixTestFailure.enabled" = true;
      "github.copilot.chat.followUps" = "always";
      "github.copilot.chat.edits.temporalContext.enabled" = true;
      "github.copilot.chat.codesearch.enabled" = true;
      "chat.agent.enabled" = true;
      "chat.agent.maxRequests" = 30;
      "github.copilot.chat.codeGeneration.useInstructionFiles" = true;
      "chat.promptFiles" = true;
      "github.copilot.chat.commitMessageGeneration.instructions" = [
        {
          "text" =
            "Summarize your changes in one line with the most important changes in the first line then add more details in the following lines.";
        }
        {
          "text" =
            "Use conventional commit message format for your commits. For example; 'feat: add new feature' or 'fix: bug fix'.";
        }
        {
          "text" =
            "If you found a breaking change, add 'BREAKING CHANGE' in the commit message then add what is breaking.";
        }
        {
          "text" =
            "Proritize the use of imperative mood in your commit messages. For example; 'fix: add new feature' instead of 'added new feature'.";
        }
        {
          "text" =
            "Proritize code changes in the commit message title over dependency changes in your commit messages.";
        }
      ];

      "beancountLangServer.journalFile" = "./main.txt";
    };
    mutableExtensionsDir = true;
    extensions = with pkgs.vscode-marketplace; [
      jnoortheen.nix-ide
      rust-lang.rust-analyzer
      nomicfoundation.hardhat-solidity
      fill-labs.dependi
      mkhl.direnv
      dotenv.dotenv-vscode
      usernamehw.errorlens
      eamodio.gitlens
      wakatime.vscode-wakatime
      tamasfe.even-better-toml
      catppuccin.catppuccin-vsc-icons
      catppuccin.catppuccin-vsc
      esbenp.prettier-vscode
      unifiedjs.vscode-mdx
      ms-azuretools.vscode-docker
      ms-vscode-remote.remote-ssh
      ms-vscode-remote.remote-containers
      ms-vscode-remote.remote-ssh-edit
      ms-vscode.remote-explorer
      ms-vscode.remote-server
      ms-vscode.remote-repositories
      ms-vscode.vscode-copilot-vision
      ms-vscode.vscode-websearchforcopilot
      ms-vscode.copilot-mermaid-diagram
      github.copilot
      github.copilot-chat
      saoudrizwan.claude-dev

      xdebug.php-debug
      phpactor.vscode-phpactor
      laravel.vscode-laravel
      devsense.composer-php-vscode
      open-southeners.laravel-pint
      embertooling.vscode-ember
      stylelint.vscode-stylelint
      editorconfig.editorconfig

      ms-python.python
      ms-python.vscode-pylance
      ms-python.debugpy
      charliermarsh.ruff
      polarmutex.beancount-langserver

      vue.volar
      bradlc.vscode-tailwindcss
      dbaeumer.vscode-eslint
      christian-kohler.npm-intellisense

      # UI
      custom-ui-style
    ];
  };
}
