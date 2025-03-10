{
  pkgs,
  config,
  lib,
  ...
}:

let
  isDarwin = pkgs.stdenv.isDarwin;
  vscode = pkgs.vscode;
  package = if isDarwin then vscode else vscode.fhs;
  fontSize = if isDarwin then 20 else 16;
  zoomLevel = if isDarwin then 2 else 0;
  originalSettingsJSON = builtins.fromJSON (builtins.readFile ./settings.json);
  settingsJSONPatch = {
    "editor.fontSize" = fontSize;
    "editor.zoomLevel" = zoomLevel;
    # You may want to add more settings in the future
  };
  settingsJSON = lib.recursiveUpdate originalSettingsJSON settingsJSONPatch;
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
    userSettings = settingsJSON;
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
      rebornix.toggle
    ];
  };
}
