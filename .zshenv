#!/bin/bash

# For anything that will use my editor.
# like `git commit -a` for example.

export VISUAL=nvim
export EDITOR=nvim

OS=$(uname)
# local bins (for custom scripts for example)
export PATH=$HOME/.local/bin:$PATH
# fnm
export PATH=$HOME/.fnm:$PATH
# yarn
export PATH=$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH
# flutter (using fvm)
export PATH=$HOME/fvm/default/bin:$PATH
export PATH=$HOME/.pub-cache/bin:$PATH
# rust
source "$HOME/.cargo/env"
export PATH=$HOME/.cargo/bin:$PATH

# android
if [[ $OS == 'Darwin' ]]; then
    export ANDROID_NDK_HOME=$HOME/Library/Android/sdk/ndk/21.3.6528147/
    export ANDROID_SDK=$HOME/Library/Android/sdk/
    export ANDROID_SDK_ROOT=$ANDROID_SDK
    export ANDROID_AVD_HOME=$HOME/.android/avd
    export PATH=$ANDROID_SDK/emulator:$ANDROID_SDK/cmdline-tools/latest/bin:$ANDROID_SDK/platform-tools:$PATH
fi

if [[ $OS == 'Linux' ]]; then
    export ANDROID_NDK_HOME=$HOME/Android/Sdk/ndk/21.3.6528147/
    export ANDROID_SDK=$HOME/Android/Sdk/
    export ANDROID_SDK_ROOT=$ANDROID_SDK
    export ANDROID_AVD_HOME=$HOME/.android/avd
    export PATH=$ANDROID_SDK/emulator:$ANDROID_SDK/cmdline-tools/latest/bin:$ANDROID_SDK/platform-tools:$PATH
    export CHROME_EXECUTABLE=google-chrome-stable
    # snaps
    export PATH=/var/lib/snapd/snap/bin:$PATH
    # Also, would make sense to clean up the $BROWSER variable
    # and set it to the default browser of your distro.
    # I do like brave browser.
    export BROWSER=brave
fi

# deno
export DENO_INSTALL=$HOME/.deno
export PATH=$DENO_INSTALL/bin:$PATH

# Spicetify
export SPICETIFY_INSTALL=$HOME/.spicetify
export PATH=$SPICETIFY_INSTALL:$PATH

# Webb
export PATH=$HOME/.webb:$PATH

# For macOS and libs installed by brew
if [[ $OS == 'Darwin' ]]; then
    export LIBRARY_PATH=$LIBRARY_PATH:/opt/homebrew/lib
    export INCLUDE_PATH=$INCLUDE_PATH:/opt/homebrew/include
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# for Linux, we need to export GPG TTY
if [[ $OS == 'Linux' ]]; then
    GPG_TTY=$(tty)
    export GPG_TTY
fi

export LC_CTYPE="en_US.UTF-8"

# FZF Theme:

# Catppuccin latte theme.
export FZF_DEFAULT_OPTS=" \
--color=bg+:#ccd0da,bg:#eff1f5,spinner:#dc8a78,hl:#d20f39 \
--color=fg:#4c4f69,header:#d20f39,info:#8839ef,pointer:#dc8a78 \
--color=marker:#dc8a78,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39"

# vi: ft=sh
