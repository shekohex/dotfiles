[ -f "$HOME"/.fzf.zsh ] && source "$HOME"/.fzf.zsh
# Starship
eval "$(starship init zsh)"
# Zoxide
eval "$(zoxide init zsh --hook pwd)"
# fnm
eval "$(fnm env --use-on-cd)"
# direnv
eval "$(direnv hook zsh)"
# Github Copilot CLI
if command -v github-copilot-cli &> /dev/null
then
    eval "$(github-copilot-cli alias -- "$0")"
fi

# vi: ft=sh
