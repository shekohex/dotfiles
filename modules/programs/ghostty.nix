{ pkgs, lib, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;

  # Shared Ghostty settings for both platforms
  ghosttySettings = {
    auto-update = "off";
    theme = "Catppuccin Mocha";
    font-family = "Maple Mono NF";
    font-size = if isDarwin then 22 else 14;
    command = "${pkgs.zellij}/bin/zellij -l welcome";
    cursor-style = "bar";
    macos-titlebar-style = "tabs";
    cursor-style-blink = true;
    mouse-hide-while-typing = true;
    background-opacity = 0.85;
    background-blur = true;
    link-url = true;
    keybind = [
      "shift+enter=text:\\n"
    ];
    shell-integration-features = "ssh-terminfo";
  };

  # Convert settings to Ghostty config format
  toGhosttyConfig = settings:
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList (key: value:
        if builtins.isList value then
          lib.concatStringsSep "\n" (map (v: "${key} = ${toString v}") value)
        else if builtins.isBool value then
          "${key} = ${if value then "true" else "false"}"
        else
          "${key} = ${toString value}"
      ) settings
    );
in
{
  # Linux: Use Home Manager's ghostty module
  programs.ghostty = lib.mkIf (!isDarwin) {
    enable = true;
    package = pkgs.ghostty;
    installVimSyntax = true;
    installBatSyntax = true;
    enableZshIntegration = true;
    settings = ghosttySettings;
  };

  # macOS: Manually create config file since package is via Homebrew
  home.file = lib.mkIf isDarwin {
    ".config/ghostty/config".text = toGhosttyConfig ghosttySettings;
  };
}
