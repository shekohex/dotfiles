#
# Shell
#

{ pkgs, ... }:

{
  programs = {
    # Certain programs are started with `/bin/bash program`, which means if I only have ZSH setup,
    # these programs won't have the correct sessionVariables present
    bash.enable = true;
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
      envExtra = if pkgs.stdenv.isDarwin then '''' else ''
        gpg-connect-agent /bye
        export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
      '';
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
        # Set the AMD ROCm version.
        export HSA_OVERRIDE_GFX_VERSION="10.3.0"
        # Set up gh copilot alias
        function gh_copilot_alias_config() {
          # Check if gh copilot is installed
          # If it is, set up the alias
          if ! command -v gh 2>&1 > /dev/null
          then
            return
          fi

          eval "$(gh copilot alias -- zsh)"
        }

        gh_copilot_alias_config
      '';
    };
  };
}
