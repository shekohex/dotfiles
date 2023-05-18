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
      historySubstringSearch = {
        enable = true;
      };
      shellAliases = {
        cat = "bat";
        cp = "cp -iv";
        mv = "mv -iv";
        rm = "rm -iv";
      };
      initExtra = ''
        # Add vi-mode plugin
        source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
      '';
      profileExtra = ''
        # Check if we have github-copilot-cli installed
        if [[ -x "$(command -v github-copilot-cli)" ]]; then
          eval "$(github-copilot-cli alias -- "$0")"
        fi
      '';
    };
  };
}
