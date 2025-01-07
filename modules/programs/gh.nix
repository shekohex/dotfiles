{ pkgs, ... }:

{
  programs.gh = {
    enable = true;
    settings = { git_protocol = "ssh"; };
    extensions = [ pkgs.gh-copilot pkgs.gh-poi pkgs.gh-markdown-preview ];
  };
}
