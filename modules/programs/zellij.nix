{ pkgs, ... }:

{
  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      theme = "catppuccin-mocha";
      on_force_close = "detach";
      pane_frames = false;
      default_layout = "compact";
    };
  };
}
