# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository using Nix Flakes, Home Manager, and nix-darwin to manage system configurations across NixOS (workstation) and macOS (macbook) systems. The configuration is highly modular and organized by function.

## Architecture

### Core Structure
- `flake.nix`: Main entry point defining nixosConfigurations and darwinConfigurations
- `hosts/`: NixOS host configurations (workstation)
- `darwin/`: macOS-specific configurations (macbook)
- `modules/`: Reusable configuration modules
  - `programs/`: Individual program configurations (git, neovim, vscode, etc.)
  - `services/`: System services (gpg-agent, ollama, pueue, etc.)
  - `hardware/`: Hardware-specific configurations (bluetooth, opengl)

### Key Patterns
- Each program module is self-contained in `modules/programs/`
- Complex programs (neovim, vscode, wezterm) have their own directories
- Configuration uses Home Manager for user-level settings
- System-wide settings are in `hosts/configuration.nix` (NixOS) or `darwin/configuration.nix` (macOS)

## Common Commands

### Building and Switching Configurations

**NixOS (workstation):**
```bash
# Rebuild and switch system configuration
sudo nixos-rebuild switch --flake .#workstation

# Test configuration without switching
sudo nixos-rebuild test --flake .#workstation

# Build configuration without activating
sudo nixos-rebuild build --flake .#workstation
```

**macOS (macbook):**
```bash
# Rebuild and switch Darwin configuration
darwin-rebuild switch --flake .#macbook

# Build without switching
darwin-rebuild build --flake .#macbook

# Show what would change
darwin-rebuild check --flake .#macbook
```

### Flake Management
```bash
# Update all flake inputs
nix flake update

# Update specific input
nix flake update nixpkgs

# Check flake metadata
nix flake metadata

# Show flake outputs
nix flake show
```

### Development
```bash
# Format Nix files
nixpkgs-fmt .

# Check for evaluation errors
nix flake check

# Garbage collection
nix-collect-garbage -d
```

## Module System

When modifying program configurations:
1. Program modules are in `modules/programs/[program].nix`
2. Each module typically exports a Home Manager configuration
3. Modules are imported in `modules/programs/default.nix`
4. Host-specific overrides go in `hosts/[hostname]/home.nix` or `darwin/home.nix`

## Important Variables
- User is always `"shady"`
- Systems: `"x86_64-linux"` (workstation), `"aarch64-darwin"` (macbook)
- Overlays are defined in host default.nix files

## Adding New Programs

To add a new program configuration:
1. Create `modules/programs/[program].nix`
2. Add import to `modules/programs/default.nix`
3. Structure should follow existing patterns (see git.nix, zsh.nix for examples)
4. Use Home Manager's program options when available

## Testing Changes

Always test configuration changes before committing:
1. Run `nix flake check` to validate
2. Build configuration with `nixos-rebuild build` or `darwin-rebuild build`
3. Test in VM if making significant system changes
4. Switch only after successful build