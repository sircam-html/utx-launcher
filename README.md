# Nix Flake for UT4 Community Launcher (NetcodePlus)

Nix flake that runs the official Linux build of the [UT4 Community Launcher](https://github.com/jmortley/netcodeplus-launcher) for **Unreal Tournament 4** on NixOS without Wine.

## Run it

```bash
nix run github:sircam-html/utx-launcher
```

### Requirements & Usage

- **Requirements**: `x86_64-linux` with flakes enabled, internet access, and an existing **Unreal Tournament 4** installation.
- **First run**: Point the launcher to your UT4 install directory to update dependencies (NetcodePlus plugin, content paks, optional UT4AC) and press **Play**.
- **Installation**: Build locally with `nix build github:sircam-html/utx-launcher` or install system-wide via `nix profile install github:sircam-html/utx-launcher`.
