{ pkgs, ... }:

{
  programs.zellij = {
    enable = false;
    enableZshIntegration = true;
    settings = {
      theme = "catppuccin-mocha";
      on_force_close = "detach";
      pane_frames = false;
      default_layout = "compact";
      # UGLY, but whatever
      # plugins = {
      #   "tab-bar location=\"zellij:tab-bar\"" = [ ];
      #   "status-bar location=\"zellij:status-bar\"" = [ ];
      #   "strider location=\"zellij:strider\"" = [ ];
      #   "compact-bar location=\"zellij:compact-bar\"" = [ ];
      #   "session-manager location=\"zellij:session-manager\"" = [ ];
      #   "weclome-screen location=\"zellij:welcome-screen\"" = {
      #     welcome_screen = true;
      #   };
      #   "filepicker location=\"zellij:strider\"" = {
      #     cwd = "/";
      #   };
      # };
    };
  };
}
