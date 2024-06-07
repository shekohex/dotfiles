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
      autosuggestion.enable = true;
      syntaxHighlighting = {
        enable = true;
      };
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
        function zvm_config() {
          ZVM_LINE_INIT_MODE=$ZVM_MODE_LAST
        }
        source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
        # Neovide specific ENV
        export NEOVIDE_TITLE_HIDDEN=true
        export NEOVIDE_FORK=true
        export NEOVIDE_TABS=false
        function gh_copilot_alias_config() {
          # Check if gh copilot is installed
          # If it is, set up the alias
          if command -v gh copilot > /dev/null; then
              eval "$(gh copilot alias -- zsh)"
          fi
        }

        gh_copilot_alias_config
      '';
    };
  };
}
