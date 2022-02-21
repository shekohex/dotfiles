# ~/.dotfiles for @shekohex

## Requirements

* git
* curl

## Installation 🔧

```bash
curl -fsSL https://git.io/shekohex-dotfiles.sh | sh
```

## Information

* Os: Arch Linux (Manjaro) / OS X.
* WM: i3-gaps
* Shell: zsh
* Terminal: kitty / iTerm2
* Editor: Neovim (Nightly)
* Theme: gruvbox
* Browser: firefox / Safari
* Package Manager: paru
* Shell Prompt: [Starship](https://starship.rs/)
* Font: Iosevka Nerd Font.

## Setup

* Install starship

```bash
curl -fsSL https://starship.rs/install.sh | bash
```

* Install [LunarVim](https://github.com/LunarVim/LunarVim) files
* Follow The [README](./.config/lvim/README.md) For the Neovim Setup.
* To Install most of my programs and get the same setup I made a `pkglist` file
that contains most of programs that I'm using.

Now I assume you are running an Arch Linux based system.
if not, you can open the pkglist and install the equivalent packages for your system.

So, to continue, first install `paru` which will help us install other programs and packages.

```bash
sudo pacman -S --needed base-devel
git clone https://aur.archlinux.org/paru.git /tmp/paru
cd /tmp/paru
makepkg -si
```

Then Simply after going through each package from the list you simply do:

`paru -S - < .pkglist` and you are ready to go!.

## See also

* [Recommended way to create your own dotfiles](https://www.atlassian.com/git/tutorials/dotfiles)

