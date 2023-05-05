# ~/.dotfiles for @shekohex

These are my dotfiles for configuring my system. Feel free to use them as you like.

## Overview

These are configuration files for different hosts/machines which includes my workstation and my macbook.

## Installation

For **Workstation:** host, after installing the base NixOS, you can run the following:

```bash
nix-env -iA nixpkgs.git
git clone https://github.com/shekohex/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
sudo nixos-rebuild --extra-experimental-features 'nix-command flakes' switch --flake .#workstation
```
