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

## Performance notes

- On first launch the wrapper installs the real DXVK DLLs into the Wine prefix
  (originals are kept as `*.bak` in `drive_c/windows/system32` and `SysWOW64`).
  This is required: the launcher enables DXVK overrides but does not ship the DLLs.
- OpenGL and Vulkan are pinned to the NVIDIA driver. Without this, the bwrap/FHS
  environment can select Mesa `llvmpipe` and the game will crawl.
- To confirm you are on the GPU, start with:
  ```bash
  DXVK_HUD=devinfo,fps nix run github:sircam-html/utx-launcher
  ```
  (use `nix run .` instead when testing a local checkout). The in-game overlay
  should show your NVIDIA GPU, never `llvmpipe`.
- If you use a different GPU, override `VK_ICD_FILENAMES` and
  `__GLX_VENDOR_LIBRARY_NAME` in your shell before launching, e.g. for AMD:
  ```bash
  VK_ICD_FILENAMES=/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json \
  __GLX_VENDOR_LIBRARY_NAME=mesa nix run github:sircam-html/utx-launcher
  ```

## Requirements & Installation

- **Requirements**: `x86_64-linux` with Nix flakes enabled, NVIDIA proprietary
  drivers with Vulkan support enabled (the default config pins the NVIDIA ICD),
  and internet access. For AMD/Intel, see the override above.
- **Local build**:
  ```bash
  nix build github:sircam-html/utx-launcher
  ```
- **Profile installation**:
  ```bash
  nix profile install github:sircam-html/utx-launcher
  ```
- **After pushing an update**, refresh the cached flake once:
  ```bash
  nix run --refresh github:sircam-html/utx-launcher
  ```
