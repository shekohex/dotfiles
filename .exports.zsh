# local bins (for custom scripts for example)
export PATH=$HOME/.local/bin:$PATH
# fnm
export PATH=$HOME/.fnm:$PATH
eval "$(fnm env --use-on-cd)"
# yarn
export PATH=$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH
# flutter (using fvm)
export PATH=$HOME/fvm/default/bin:$PATH
export PATH=$HOME/.pub-cache/bin:$PATH
# rust
export PATH=$HOME/.cargo/bin:$PATH
# android
export ANDROID_NDK_HOME=$HOME/Library/Android/sdk/ndk/21.3.6528147/
export ANDROID_SDK=$HOME/Library/Android/sdk/
export ANDROID_SDK_ROOT=$ANDROID_SDK_HOME
export ANDROID_AVD_HOME=$HOME/.android/avd
export PATH=$ANDROID_SDK/emulator:$ANDROID_SDK/cmdline-tools/latest/bin:$ANDROID_SDK/platform-tools:$PATH
# deno
export DENO_INSTALL=$HOME/.deno
export PATH=$DENO_INSTALL/bin:$PATH

# Spicetify
export SPICETIFY_INSTALL=$HOME/.spicetify-cli
export PATH=$SPICETIFY_INSTALL:$PATH

# Webb
export PATH=$HOME/.webb:$PATH

# For macOS and libs installed by brew
if [[ `uname` == 'Darwin' ]]; then
    export LIBRARY_PATH=$LIBRARY_PATH:/opt/homebrew/lib
    export INCLUDE_PATH=$INCLUDE_PATH:/opt/homebrew/include
fi

# for Linux, we need to export GPG TTY
if [[ `uname` == 'Linux' ]]; then
    GPG_TTY=$(tty)
    export GPG_TTY
fi

export LC_CTYPE="en_US.UTF-8"
