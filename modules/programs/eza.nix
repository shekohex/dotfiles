{
  programs.eza = {
    enable = true;
    git = true;
    icons = true;
    extraOptions = [
      "-lhm"
      "--sort=type"
      "--group-directories-first"
    ];
  };
}
