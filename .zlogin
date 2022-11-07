[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh
# Starship
eval "$(starship init zsh)"
# Zoxide
eval "$(zoxide init zsh --hook pwd)"
# fnm
eval "$(fnm env --use-on-cd)"
