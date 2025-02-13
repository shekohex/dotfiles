{ pkgs, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
in
{
  programs.alacritty = {
    enable = false;
    settings = {
      general = {
        import = [ "${pkgs.alacritty-theme}/catppuccin_mocha.toml" ];
      };
      window = {
        decorations = if isDarwin then "Buttonless" else "None";
        # startup_mode = if isDarwin then "SimpleFullscreen" else "Maximized";
        dynamic_padding = true;
        padding = {
          x = 2;
          y = 8;
        };
        blur = if isDarwin then true else false;
      };
      font = {
        normal = {
          family = "JetBrainsMono Nerd Font Mono";
          style = "Regular";
        };
        size = if isDarwin then 20 else 16;
      };
      bell = {
        animation = "EaseOutExpo";
      };
      cursor = {
        style = {
          shape = "Beam";
          blinking = "Off";
        };
        vi_mode_style = {
          shape = "Block";
          blinking = "Off";
        };
      };
      terminal = {
        shell = {
          program = "${pkgs.zellij}/bin/zellij";
          args = [
            "-l"
            "welcome"
          ];
        };
        osc52 = "CopyPaste";
      };
      mouse = {
        hide_when_typing = true;
      };
    };
  };
}
