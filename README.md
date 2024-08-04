# nixos

Reproducable configuration for various devices.

## Tasks

### Switch-system

Requires: switch-nixos, switch-home-manager

Rebuilds NixOS and home-manager and applies all configration changes.

### Switch-NixOS

Rebuilds the system-wide NixOS configuration and applies it.

```bash
sudo nixos-rebuild switch --flake ".#`hostname`"
```

### Switch-home-manager

Rebuilds the home directory of the user and applies it.

```bash
home-manager switch --flake ".#$USER@`hostname`"
```

### Garbage-collect

```bash
nix-collect-garbage --quiet
```
