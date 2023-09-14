{
  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    userSettings = {
      # Disable telemetry
      "telemetry.telemetryLevel" = "off";
      "editor.fontFamily" = "'JetBrainsMono Nerd Font Mono'; 'JetBrainsMono NF'; 'Ubuntu Mono';  monospace; 'Segoe UI Emoji'; 'Droid Sans Fallback'";
      "editor.parameterHints.cycle" = true;
      "editor.letterSpacing" = 0.5;
      "editor.fontWeight" = "500";
      "editor.fontLigatures" = true;
      "editor.smoothScrolling" = true;
      "editor.formatOnPaste" = true;
      "editor.fastScrollSensitivity" = 2;
      # "window.titleBarStyle" = "custom";
      # "editor.mouseWheelScrollSensitivity"= 0.01;
      "editor.minimap.enabled" = false;
      "terminal.integrated.confirmOnExit" = "hasChildProcesses";
      "terminal.integrated.cursorBlinking" = true;
      "editor.cursorWidth" = 5;
      "editor.cursorBlinking" = "solid";
      "explorer.openEditors.visible" = 0;
      "workbench.editor.showTabs" = false;
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
      };
      "editor.suggestSelection" = "first";
      "terminal.integrated.fontSize" = 16;
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
        "editor.wordBasedSuggestions" = false;
      };
      "extensions.ignoreRecommendations" = false;
      "workbench.startupEditor" = "none";
      "editor.fontSize" = 16;
      "editor.inlineSuggest.enabled" = true;
      "editor.bracketPairColorization.enabled" = true;
      "editor.guides.bracketPairs" = true;
      "editor.tabCompletion" = "onlySnippets";
      "diffEditor.codeLens" = true;
      "editor.suggest.preview" = true;
      "search.useGlobalIgnoreFiles" = true;
      "debug.confirmOnExit" = "always";
      "extensions.autoUpdate" = "onlyEnabledExtensions";
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
      "workbench.iconTheme" = "vscode-icons";
      "workbench.productIconTheme" = "fluent-icons";
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
      "rust-analyzer.runnableEnv" = {
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

    };
    mutableExtensionsDir = true;
    extensions = [ ];
  };
}
