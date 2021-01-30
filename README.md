<p align="center">
   <img src="./dotfiles.jpeg">
</p>

# ~/.dotfiles for @shekohex

## Requirements

* git
* curl

## Installation 🔧

```bash
curl -sSf https://raw.githubusercontent.com/shekohex/dotfiles/master/init.sh | sh
```

## Information

* Os: Arch Linux (Manjaro)
* WM: i3
* Terminal: alacritty
* Editor: Neovim (Nightly)
* Theme: gruvbox
* Browser: firefox
* Package Manager: paru

## Setup

To Install most of my programs and get the same setup I made a `pkglist` file that
contains most of programs that I'm using.

Now I assume you are running an Arch Linux based system.
if not, you can open the pkglist and install the equivalent packages for your system.

First install `paru` which will help us install other programs and packages.

```bash
sudo pacman -S --needed base-devel
git clone https://aur.archlinux.org/paru.git /tmp/paru
cd /tmp/paru
makepkg -si
```

Then Simply after reviweing each package from the list you simply do:

`paru -S - < .pkglist` and you are ready to go!.

## See also

* [Recommended way to create your own dotfiles](https://www.atlassian.com/git/tutorials/dotfiles)

