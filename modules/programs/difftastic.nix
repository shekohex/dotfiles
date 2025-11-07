{ ... }:

{
  programs.difftastic = {
    enable = true;
    git.enable = true;
    options = {
      display = "inline";
    };
  };
}
