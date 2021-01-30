#!/bin/env sh

# Check if the git installed or not.
command -v git >/dev/null 2>&1 || { echo "Git is not installed!"; exit 1; }

git clone --bare git@github.com:shekohex/dotfiles.git $HOME/.dotfiles || \
  { echo "Failed to clone the github.com/shekohex/dotfiles"; exit 2; }

function dotfiles {
   git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}

mkdir -p .config-backup
dotfiles checkout
if [ $? = 0 ]; then
  echo "Checked out dotfiles...";
  else
    echo "Backing up pre-existing dot files.";
    dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
fi;

dotfiles checkout
dotfiles config status.showUntrackedFiles no


