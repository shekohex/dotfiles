#
# Shell
#

{ pkgs, ... }:

{
  programs = {
    zsh = {
      enable = true;
      autocd = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      history = {
        size = 1000000;
        extended = true;
      };
      shellAliases = {
        cat = "bat";
        cp = "cp -iv";
        mv = "mv -iv";
        rm = "rm -iv";
      };
      loginExtra = ''
        # Swag
        ${pkgs.nitch}/bin/nitch
      '';
    };
  };
}
