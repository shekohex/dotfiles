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
  zoomLevel = if isDarwin then 1.25 else 0;
  originalSettingsJSON = builtins.fromJSON (builtins.readFile ./settings.json);
  keybindingsJSON = builtins.fromJSON (builtins.readFile ./keybindings.json);
  settingsJSONPatch = {
    "editor.fontSize" = fontSize;
    "window.zoomLevel" = zoomLevel;
    "gitlens.ai.generateCommitMessage.customInstructions" = builtins.concatStringsSep "\n" [
      "You are a git wizard, and an expert in writing commit messages, FOLLOW THE INSTRUCTIONS BELOW EXACTLY."
      "## Write short commit messages:"
      "- The first line should be a short summary of the changes in imperative mood following the conventional commit message format."
      "- Remember to mention the files that were changed, and what was changed"
      "- Explain the 'why' behind changes"
      "- Use bullet points for multiple changes"
      "- Proritize code changes in the commit message title over dependency changes in your commit messages."
      "- Think carefully before you write your commit message."
      "- What you write will be passed directly to git commit -m \"[message]\""
      " - DO NOT include the backtick (`) in the beginning and end of the commit message."
      ""
      "## Commit Message Format:"
      "Each commit message consists of a header, a body and a footer. The header has a special format that includes a type, a scope and a subject. The type and subject are required, all the other parts are optional."
      "<type>[optional scope][!]: <subject>"
      "<BLANK LINE>"
      "[optional body]"
      "<BLANK LINE>"
      "[optional footer]"
      ""
      "## Type:"
      "The type is a mandatory field that describes the type of change that is being made. The type should be one of the following:"
      "- feat: A new feature"
      "- fix: A bug fix"
      "- docs: Documentation only changes"
      "- style: Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)"
      "- refactor: A code change that neither fixes a bug nor adds a feature"
      "- perf: A code change that improves performance"
      "- test: Adding missing or correcting existing tests"
      "- ci: Changes to our CI configuration files and scripts"
      "- revert: Revert to a commit or a previous state"
      "- chore: Other changes that don't modify src or test files"
      "- build: Changes that affect the build system or external dependencies"

      "## Scope:"
      "The scope is a optional field that describes the scope of the change. The scope are usually the name of the
      module/package/crate/library affected. and we are using the directory name as the scope."
      "## Subject:"
      "The subject is a mandatory field that describes the change in a short and concise way. The subject should be written in the imperative mood, and should not exceed 72 characters. The subject should not end with a period."
      "## Body:"
      "The body is an optional field that describes the change in more detail. The body should be written in the present tense, and should not exceed 72 characters per line. The body should explain the 'why' behind the change, and should not be a repeat of the subject."
      "## Footer:"
      "The footer is an optional field that describes any breaking changes or issues that are related to the change. The footer should be written in the present tense, and should not exceed 72 characters per line. The footer should be preceded by a blank line."
    ];
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
        extensions = import ./extensions.nix {
          inherit pkgs;
          inherit config;
        };
      };
    };
  };
}
