{ pkgs, ... }:
{
  programs.zellij = {
    enable = true;
    # We use wezterm that will start zellij for us
    enableZshIntegration = false;
    settings = {
      theme = "catppuccin-mocha";
      on_force_close = "detach";
      pane_frames = false;
      default_layout = "compact";
    };
  };
}
