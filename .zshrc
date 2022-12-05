# Plugins:
[ -f $HOME/.antigen.zsh ] && source $HOME/.antigen.zsh

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

# History Configrations
HISTFILE="$HOME/.zsh_history"
HISTSIZE=500000
SAVEHIST=500000
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.


# Alias
alias vim=lvim
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias :q=exit # I like vim :)
alias cp="cp -iv"
alias mv="mv -iv"
alias rm="rm -iv"
alias cls=clear
alias cat=bat
alias ls="exa -lhm --icons --git -s type --group-directories-first"
alias hexdump=hx
alias htop=btm
alias du=dust
alias http=xt

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

export PATH="$PATH:/home/shady/.foundry/bin"
