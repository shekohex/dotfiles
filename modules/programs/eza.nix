{
  programs.eza = {
    enable = true;
    enableAliases = true;
    git = true;
    icons = true;
    extraOptions = [
      "-lhm"
      "--sort=type"
      "--group-directories-first"
    ];
  };
}
