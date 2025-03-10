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
    enable = false;
    package = package;
    mutableExtensionsDir = true;
    profiles = {
      default = {
        enableUpdateCheck = false;
        enableExtensionUpdateCheck = false;
        userSettings = settingsJSON;
        extensions = import ./extensions.nix;
      };
    };
  };
}
