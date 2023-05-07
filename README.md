# ~/.dotfiles for @shekohex

These are my dotfiles for configuring my system. Feel free to use them as you like.

## Overview

These are configuration files for different hosts/machines which includes my _workstation_ and my _macbook_.

## Installation

For **workstation:** host, after installing the base NixOS, you can run the following:

```
nix-env -iA nixpkgs.git
git clone https://github.com/shekohex/dotfiles.git ~/.dotfiles && cd ~/.dotfiles
sudo nixos-rebuild --extra-experimental-features 'nix-command flakes' switch --flake .#workstation
```

For **macbook:** host, you need to follow these to steps:

1. Install Nix (_skip if already installed_):

```bash
sh <(curl -L https://nixos.org/nix/install)

echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

2. Install the dotfiles:

```
nix-env -iA nixpkgs.git
git clone https://github.com/shekohex/dotfiles.git ~/.dotfiles && cd ~/.dotfiles
nix build .#darwinConfigurations.macbook.system
./result/sw/bin/darwin-rebuild switch --flake .#macbook
```
Since darwin is now added to the `PATH`, you can build it from anywhere in the system. In this example it is rebuilt from inside the flake directory:

```
darwin-rebuild switch --flake .#
```

This will rebuild the configuration and automatically activate it.

<br>

#### License

<sup>
Licensed under either of <a href="LICENSE-APACHE">Apache License, Version
2.0</a> or <a href="LICENSE-MIT">MIT license</a> at your option.
</sup>

<br>

<sub>
Unless you explicitly state otherwise, any contribution intentionally submitted
for inclusion in this project by you, as defined in the Apache-2.0 license,
shall be dual licensed as above, without any additional terms or conditions.
</sub>
