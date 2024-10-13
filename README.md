# NixOS

If you're making a lot of changes, skip the cache by adding the `--refresh` flag.

## Tasks

### hetzner-builder-x86_64-switch

```bash
sudo nixos-rebuild switch --flake github:a-h/nixos#hetzner-builder-x86_64
```

### nixos-switch-aarch64

```
sudo nixos-rebuild switch --flake github:a-h/nixos#builder-aarch64
```

### nixos-switch-aarch64-local

```bash
sudo nixos-rebuild switch --flake .#nixos-aarch64
```

### start

See https://ryan.himmelwright.net/post/utmctl-nearly-headless-vms/

```bash
utmctl start aarch64
utmctl start aarch64
```
