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

# Starship
eval "$(starship init zsh)"
# Zoxide
eval "$(zoxide init zsh)"

# Now the other files.

source ~/.exports
source ~/.aliases

