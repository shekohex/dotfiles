{
  programs = {
    wezterm = {
      enable = false;
      extraConfig = builtins.readFile ./wezterm.lua;
    };
  };
}
