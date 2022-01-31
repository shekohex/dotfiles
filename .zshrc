# For anything that will use my editor.
# like `git commit -a` for example.
export VISUAL=nvim
export EDITOR=nvim

# Plugins:
[ -f $HOME/antigen.zsh ] && source $HOME/antigen.zsh

antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
# Must be last one.
antigen bundle zsh-users/zsh-history-substring-search
# Tell Antigen that you're done.
antigen apply

# Plugin Config
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh

# Starship
eval "$(starship init zsh)"
# Zoxide
eval "$(zoxide init zsh --hook pwd)"
# Now the other files.
source $HOME/.exports
source $HOME/.aliases



