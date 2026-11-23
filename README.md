# Nix Flake for UT4 Community Launcher (NetcodePlus)

Self-contained Nix flake that runs the official Linux AppImage of the [UT4 Community Launcher](https://github.com/jmortley/netcodeplus-launcher) for **Unreal Tournament 4** on NixOS with bundled Wine Staging, DXVK, and Vulkan dependencies—no Lutris or system-wide Wine setup required.

## Run it

```bash
nix run github:sircam-html/utx-launcher
```

## First-Time Setup

1. **Configure the Wine Runner path**: On first launch, open **Settings** inside the launcher and set the Wine runner directory to:
   ```text
   ~/.local/share/ut4-wine-runner
   ```
   *(The flake automatically creates and updates this directory with symlinks to the bundled Wine binaries and initializes a writable Wine prefix at `~/.local/share/ut4-wine-prefix`.)*
2. **Locate or install UT4**: Point the launcher to your existing **Unreal Tournament 4** installation directory (or let the launcher download and unpack the community game package for you).
3. **Update & Play**: Let the launcher update the NetcodePlus plugin and press **Play**.

## Requirements & Installation

- **Requirements**: `x86_64-linux` with Nix flakes enabled, Vulkan-capable GPU drivers, and internet access.
- **Local build**:
  ```bash
  nix build github:sircam-html/utx-launcher
  ```
- **Profile installation**:
  ```bash
  nix profile install github:sircam-html/utx-launcher
  ```
