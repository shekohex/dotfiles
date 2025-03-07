{
  pkgs,
  config,
  ...
}:

let
  isDarwin = pkgs.stdenv.isDarwin;
  vscode = pkgs.vscode;
  package = if isDarwin then vscode else vscode.fhs;
  fontSize = if isDarwin then 20 else 16;
  zoomLevel = if isDarwin then 2 else 0;
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

      "[handlebars]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };

      "[html]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };

      "[javascript]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };

      "[json]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };

      "[jsonc]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };

      "[python]" = {
        "editor.codeActionsOnSave" = {
          "source.fixAll" = "explicit";
          "source.organizeImports" = "explicit";
        };
        "editor.defaultFormatter" = "charliermarsh.ruff";
        "editor.formatOnSave" = true;
      };

      "[typescript]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };

      "[vue]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };

      "beancountLangServer.journalFile" = "./main.txt";
      "breadcrumbs.enabled" = false;
      "catppuccin.accentColor" = "teal";
      "catppuccin.extraBordersEnabled" = false;
      "chat.agent.enabled" = true;
      "chat.agent.maxRequests" = 30;
      "chat.commandCenter.enabled" = true;
      "chat.promptFiles" = true;
      "custom-ui-style.preferRestart" = true;

      "custom-ui-style.electron" = {
        "frame" = false;
        "transparent" = true;
        "visualEffectState" = "active";
        "vibrancy" = "fullscreen-ui";
      };

      "custom-ui-style.font.sansSerif" = "'JetBrainsMono Nerd Font'";
      "custom-ui-style.font.monospace" = "'JetBrainsMono Nerd Font'";

      "custom-ui-style.webview.stylesheet" = {
        ".editor-group-watermark" = {
          "font-size" = "15px !important";
        };
        ".filematch .monaco-count-badge" = "padding: 5px 6px 0 6px !important";
        ".filematch .monaco-icon-label:before, .custom-list-row.results .monaco-list-row .monaco-icon-label:before" =
          "background-position: 0 bottom !important";
        ".inline-tabs-placeholder" = "display: none !important;";
        ".monaco-editor .cursor" =
          "background: linear-gradient(to bottom, #00FF00, #00FF00) !important;  color: #161616 !important";
        ".monaco-editor .scroll-decoration" = "display: none !important";
        ".monaco-hover" = "border: 1px solid #007ACC !important;";
        ".monaco-scrollable-element > .shadow.top" = "display: none !important";
        ".monaco-workbench .monaco-list:not(.element-focused):focus:before" = "outline: none !important";
        ".panel .composite.title" = "visibility: hidden !important";
        ".quick-input-list-row div" = "display: flex !important; align-items: center !important";
        ".quick-input-widget" = {
          "background-color" = "rgb(30, 30, 30) !important";
          "border" = "1px solid #007ACC !important";
          "border-radius" = "10px !important";
          "left" = "41% !important";
          "padding" = "15px !important";
          "top" = "250px !important";
          "width" = "900px !important";
        };
        ".quick-input-widget .monaco-inputbox" = {
          "border-radius" = "5px!important";
          "padding" = "10px !important";
        };
        ".quick-input-widget .monaco-list-row" =
          "position:static!important;border-bottom: 1px solid #333942;padding:5px!important;height:auto!important;";
        ".quick-input-widget .monaco-list-rows" = "top: 0 !important;max-height:670px;min-height:300px;";
        ".quick-input-widget .quick-input-header" = "padding:0px!important;margin-bottom:10px;";
        ".quick-input-widget .quick-input-list .quick-input-list-entry.quick-input-list-separator-border" =
          "border-top-width:0px!important;";
        ".quick-input-widget .quick-input-list-entry" = "position:relative;padding:0 5px 0px 15px;";
        ".quick-input-widget .quick-input-list-entry .codicon[class*=codicon-]" = "font-size:12px;";
        ".quick-input-widget.show-file-icons, .editor-widget.find-widget" = "box-shadow: none !important";
        ".sidebar" = "border: none !important";
        ".sidebar .title-label" = "padding: 0 !important";
        ".sidebar .title-label h2" = "line-height: 2.8 !important";
        ".title-actions" = "display: none !important";
        ".title.show-file-icons .label-container .monaco-icon-label.file-icon" =
          "padding-bottom: 6px !important";
        ".tree" = "border: 1px solid #007ACC !important;";
      };

      "custom-ui-style.stylesheet" = {
        "span:not([class*='dyn-rule'])+span[class*='dyn-rule']" = {
          "border-top-left-radius" = "3px";
          "border-bottom-left-radius" = "3px";
        };
        "span[class*='dyn-rule']:has(+span:not([class*='dyn-rule']))" = {
          "border-top-right-radius" = "3px";
          "border-bottom-right-radius" = "3px";
        };
        ".cdr" = {
          "border-radius" = "3px";
        };
        ".quick-input-widget" = {
          "top" = "25vh !important";
        };
        ".overlayWidgets .editorPlaceholder" = {
          "line-height" = "unset !important";
        };
      };

      "dart.debugExternalPackageLibraries" = true;
      "dart.debugSdkLibraries" = false;
      "debug.confirmOnExit" = "always";
      "debug.inlineValues" = "auto";
      "diffEditor.codeLens" = true;
      "editor.accessibilityPageSize" = 5;
      "editor.bracketPairColorization.enabled" = true;
      "editor.cursorBlinking" = "solid";
      "editor.cursorSmoothCaretAnimation" = "on";
      "editor.cursorWidth" = 5;
      "editor.fastScrollSensitivity" = 2;
      "editor.fontFamily" = "'JetBrainsMono Nerd Font', Menlo, Monaco, 'Courier New', monospace";
      "editor.fontLigatures" = true;
      "editor.fontSize" = fontSize;
      "editor.fontWeight" = "500";
      "editor.formatOnPaste" = true;
      "editor.formatOnSave" = true;
      "editor.glyphMargin" = true;
      "editor.guides.bracketPairs" = true;
      "editor.hideCursorInOverviewRuler" = true;
      "editor.inlineSuggest.edits.codeShifting" = true;
      "editor.inlineSuggest.enabled" = true;
      "editor.letterSpacing" = 0.5;
      "editor.lineNumbers" = "on";
      "editor.minimap.enabled" = false;
      "editor.parameterHints.cycle" = true;
      "editor.quickSuggestionsDelay" = 5;
      "editor.renderControlCharacters" = false;
      "editor.renderWhitespace" = "boundary";

      "editor.semanticTokenColorCustomizations" = {
        "rules" = {
          "*.global" = "#cc881a";
          "*.mutable" = {
            "fontStyle" = "underline";
          };
          "*.static" = "#cc881a";
          "function.unsafe" = "#f73028";
          "method.unsafe" = "#f73028";
          "typeAlias" = "#aab01e";
        };
      };

      "editor.smoothScrolling" = true;
      "editor.suggest.localityBonus" = true;
      "editor.suggest.preview" = true;
      "editor.suggestSelection" = "first";
      "editor.tabCompletion" = "onlySnippets";
      "editor.tabSize" = 2;
      "errorLens.scrollbarHackEnabled" = true;
      "evenBetterToml.formatter.columnWidth" = 120;
      "explorer.openEditors.visible" = 1;
      "extensions.autoCheckUpdates" = false;
      "extensions.autoUpdate" = false;

      "extensions.experimental.affinity" = {
        "asvetliakov.vscode-neovim" = 1;
      };

      "extensions.ignoreRecommendations" = true;

      "files.associations" = {
        "*.tera" = "html";
        ".env*" = "dotenv";
      };

      "files.exclude" = {
        "**/*.g.dart" = true;
        "**/*.pyc" = true;
        "**/.classpath" = true;
        "**/.dart_tool" = true;
        "**/.factorypath" = true;
        "**/.idea" = true;
        "**/.project" = true;
        "**/.settings" = true;
        "**/__pycache__" = true;
        "**/build" = true;
        "**/dist" = true;
        "**/target" = true;
        "**/vendor" = true;
      };

      "files.insertFinalNewline" = true;

      "files.watcherExclude" = {
        "**/build/**" = true;
        "**/node_modules/**" = true;
        "**/target/**" = true;
        "**/vendor/**" = true;
      };

      "git.autoRepositoryDetection" = false;
      "git.autofetch" = true;
      "git.confirmSync" = false;
      "git.enableCommitSigning" = true;
      "git.enableSmartCommit" = true;

      "github.copilot.chat.codeGeneration.useInstructionFiles" = true;
      "github.copilot.chat.codesearch.enabled" = true;
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

      "github.copilot.chat.editor.temporalContext.enabled" = true;
      "github.copilot.chat.edits.temporalContext.enabled" = true;
      "github.copilot.chat.fixTestFailure.enabled" = true;
      "github.copilot.chat.followUps" = "always";
      "github.copilot.chat.generateTests.codeLens" = true;
      "github.copilot.chat.search.semanticTextResults" = true;
      "github.copilot.editor.enableAutoCompletions" = true;
      "github.copilot.editor.enableCodeActions" = true;

      "github.copilot.enable" = {
        "*" = true;
        "markdown" = true;
        "plaintext" = true;
        "yaml" = true;
      };

      "github.copilot.nextEditSuggestions.enabled" = true;
      "gitlens.blame.avatars" = false;
      "gitlens.currentLine.enabled" = false;
      "gitlens.currentLine.scrollable" = false;
      "gitlens.hovers.currentLine.over" = "line";
      "gitlens.hovers.enabled" = false;
      "javascript.inlayHints.enumMemberValues.enabled" = true;
      "javascript.inlayHints.functionLikeReturnTypes.enabled" = true;
      "javascript.inlayHints.parameterNames.enabled" = "all";
      "javascript.inlayHints.parameterTypes.enabled" = true;
      "javascript.inlayHints.propertyDeclarationTypes.enabled" = true;
      "javascript.inlayHints.variableTypes.enabled" = true;
      "javascript.updateImportsOnFileMove.enabled" = "always";
      "lldb.suppressUpdateNotifications" = true;
      "markdown.preview.lineHeight" = 1.2;
      "notebook.formatOnSave.enabled" = true;

      "remote.SSH.remotePlatform" = {
        "workstation" = "linux";
      };

      "ruff.nativeServer" = "on";
      "rust-analyzer.cargo.autoreload" = true;

      "rust-analyzer.cargo.extraEnv" = {
        "SKIP_WASM_BUILD" = "1";
      };

      "rust-analyzer.check.command" = "clippy";
      "rust-analyzer.check.extraArgs" = [
        "--tests"
        "--"
        "-W"
        "clippy::complexity"
        "-W"
        "clippy::perf"
      ];

      "rust-analyzer.check.extraEnv" = {
        "SKIP_WASM_BUILD" = "1";
      };

      "rust-analyzer.checkOnSave" = true;
      "rust-analyzer.completion.autoimport.enable" = true;
      "rust-analyzer.completion.callable.snippets" = "add_parentheses";
      "rust-analyzer.completion.postfix.enable" = true;
      "rust-analyzer.debug.openDebugPane" = true;
      "rust-analyzer.diagnostics.experimental.enable" = false;
      "rust-analyzer.imports.granularity.enforce" = true;
      "rust-analyzer.imports.granularity.group" = "module";
      "rust-analyzer.imports.group.enable" = true;
      "rust-analyzer.imports.prefix" = "crate";
      "rust-analyzer.inlayHints.maxLength" = 3;
      "rust-analyzer.inlayHints.renderColons" = false;
      "rust-analyzer.inlayHints.typeHints.enable" = true;
      "rust-analyzer.lens.enable" = true;

      "rust-analyzer.runnables.extraEnv" = {
        "SKIP_WASM_BUILD" = "1";
      };

      "search.useGlobalIgnoreFiles" = true;
      "security.workspace.trust.untrustedFiles" = "newWindow";
      "telemetry.telemetryLevel" = "off";
      "terminal.external.osxExec" = "iTerm.app";
      "terminal.external.windowsExec" = "pwsh.exe -NoLogo";
      "terminal.integrated.confirmOnExit" = "hasChildProcesses";
      "terminal.integrated.cursorBlinking" = true;
      "terminal.integrated.defaultProfile.linux" = "zsh";
      "terminal.integrated.defaultProfile.windows" = "PowerShell";
      "terminal.integrated.fontLigatures.enabled" = true;
      "terminal.integrated.fontSize" = 20;
      "terminal.integrated.gpuAcceleration" = "off";
      "terminal.integrated.localEchoExcludePrograms" = [
        "vim"
        "vi"
        "nano"
        "tmux"
        "nvim"
      ];

      "terminal.integrated.profiles.windows" = {
        "PowerShell" = {
          "args" = [ "-NoLogo" ];
          "source" = "PowerShell";
        };
      };

      "terminal.integrated.tabs.title" = "\${local} \${process}";
      "typescript.inlayHints.enumMemberValues.enabled" = true;
      "typescript.inlayHints.functionLikeReturnTypes.enabled" = true;
      "typescript.inlayHints.parameterNames.enabled" = "all";
      "typescript.inlayHints.parameterTypes.enabled" = true;
      "typescript.inlayHints.propertyDeclarationTypes.enabled" = true;
      "typescript.inlayHints.variableTypes.enabled" = true;
      "typescript.updateImportsOnFileMove.enabled" = "always";
      "update.mode" = "none";
      "window.titleBarStyle" = "native";
      "window.zoomLevel" = zoomLevel;
      "workbench.activityBar.location" = "hidden";
      "workbench.colorTheme" = "Catppuccin Mocha";
      "workbench.commandPalette.experimental.askChatLocation" = "quickChat";
      "workbench.commandPalette.preserveInput" = true;
      "workbench.editor.limit.enabled" = true;
      "workbench.editor.limit.value" = 5;
      "workbench.editor.showTabs" = "single";
      "workbench.editor.tabSizing" = "shrink";
      "workbench.iconTheme" = "catppuccin-mocha";
      "workbench.productIconTheme" = "Default";
      "workbench.sideBar.location" = "right";
      "workbench.startupEditor" = "none";
      "workbench.statusBar.visible" = false;

      "editor.tokenColorCustomizations" = {
        "[*Light*]" = {
          "textMateRules" = [
            {
              "scope" = "ref.matchtext";
              "settings" = {
                "foreground" = "#000";
              };
            }
          ];
        };
        "[*Dark*]" = {
          "textMateRules" = [
            {
              "scope" = "ref.matchtext";
              "settings" = {
                "foreground" = "#fff";
              };
            }
          ];
        };
        "textMateRules" = [
          {
            "scope" = "keyword.other.dotenv";
            "settings" = {
              "foreground" = "#FF000000";
            };
          }
        ];
      };

      "window.commandCenter" = false;
      "window.customTitleBarVisibility" = "never";
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
      subframe7536.custom-ui-style
    ];
  };
}
