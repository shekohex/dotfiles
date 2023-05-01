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
      loginExtra = ''
        # Swag
        ${pkgs.nitch}/bin/nitch
      '';
    };
  };
}
