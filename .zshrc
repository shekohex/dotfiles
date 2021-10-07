# For anything that will use my editor.
# like `git commit -a` for example.
export VISUAL=nvim
export EDITOR=nvim

# Setup.
# Source manjaro-zsh-configuration
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
  source /usr/share/zsh/manjaro-zsh-config
fi

# Use manjaro zsh prompt
if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
  source /usr/share/zsh/manjaro-zsh-prompt
fi

compinit -d ~/.cache/zsh/zcompdump-$ZSH_VERSION
kitty + complete setup zsh | source /dev/stdin

# Starship
eval "$(starship init zsh)"
# Zoxide
eval "$(zoxide init zsh --hook pwd)"
# McFly
eval "$(mcfly init zsh)"

# Now the other files.

source ~/.exports
source ~/.aliases

# disabled since we are using mcfly now
# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# fnm
export PATH=/home/shady/.fnm:$PATH
eval "`fnm env`"
