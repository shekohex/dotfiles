{
  pkgs,
  config,
  lib,
  ...
}:

let
  isDarwin = pkgs.stdenv.isDarwin;
  windsurf = pkgs.windsurf;
  package = if isDarwin then windsurf else windsurf.fhs;
  fontSize = if isDarwin then 20 else 16;
  zoomLevel = if isDarwin then 2 else 0;
  keybindingsJSON = builtins.fromJSON (builtins.readFile ./vscode/keybindings.json);
  originalSettingsJSON = builtins.fromJSON (builtins.readFile ./vscode/settings.json);
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
          "openvscode-server" = "OpenVSCode Server";
          "windsurf" = "Windsurf";
          "cursor" = "Cursor";
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
    mutableExtensionsDir = true;
    profiles = {
      default = {
        enableUpdateCheck = false;
        enableExtensionUpdateCheck = false;
        userSettings = settingsJSON;
        keybindings = keybindingsJSON;
        extensions =
          lib.lists.subtractLists
            # Remove the following extensions from the default list
            (with pkgs.vscode-marketplace; [
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
            ])
            (
              import ./vscode/extensions.nix {
                inherit pkgs;
                inherit config;
              }
            );
      };
    };

  };
}
