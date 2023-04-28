[ -f "$HOME"/.fzf.zsh ] && source "$HOME"/.fzf.zsh
# Starship
if command -v starship &> /dev/null
then
    eval "$(starship init zsh)"
fi
# Zoxide
if command -v zoxide &> /dev/null
then
    eval "$(zoxide init zsh)"
fi
# fnm
if command -v fnm &> /dev/null
then
    eval "$(fnm env --use-on-cd)"
fi
# direnv
if command -v direnv &> /dev/null
then
    eval "$(direnv hook zsh)"
fi
# Github Copilot CLI
if command -v github-copilot-cli &> /dev/null
then
    eval "$(github-copilot-cli alias -- "$0")"
fi

# vi: ft=sh
