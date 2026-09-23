{ ... }:

{
  programs.difftastic = {
    enable = false;
    git.enable = true;
    options = {
      display = "inline";
    };
  };
}
