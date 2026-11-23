# Nix Flake for UT4 Community Launcher (NetcodePlus)

Nix flake that runs the official Linux build of the [UT4 Community Launcher](https://github.com) for **Unreal Tournament 4** on NixOS.

Unlike Windows-only launchers, upstream provides a native Linux AppImage. This flake fetches the official `UT4-Community-Launcher-x86_64.AppImage`, wraps it with `appimageTools` along with its required WebKit/GTK/GPG runtime libraries, and runs it natively without needing Wine for the launcher itself.

## Run it

```bash
nix run github:sircam-html/ut4-community-launcher
```

*(Replace `ut4-community-launcher` with your actual GitHub repository name if different.)*

The same command works in `fish` and `bash`. No cloning required.

### Requirements

- `x86_64-linux`.
- Flakes enabled.
- An internet connection on the first run.
- An existing **Unreal Tournament 4** installation (running inside a Wine, Proton, or Lutris prefix on Linux).

### First run

Nix downloads the AppImage and its sandboxed runtime libraries, then opens the launcher window:

1. Point the launcher to your Unreal Tournament 4 install directory.
2. The launcher will automatically download and keep the **NetcodePlus plugin**, **content paks**, and optional **UT4AC** anti-cheat up to date.
3. Press **Play** to launch UT4 through your Wine/Proton setup.

### Updating the launcher

Upstream publishes new Linux AppImage releases on GitHub. Since `/nix/store` is read-only, the launcher's built-in self-updater cannot overwrite the binary; instead, bump the flake:

1. Change `version = "1.9.0";` and the release tag in `url` inside `flake.nix` to the new version.
2. Update `hash` for the new AppImage. If you leave the old one, `nix run` fails and prints the expected `got: sha256-...` hash, or you can prefetch it directly:

   ```bash
   nix store prefetch-file https://github.com/releases/download/v<version>/UT4-Community-Launcher-x86_64.AppImage
   ```

## Package & Installation

To build the wrapped package locally:

```bash
nix build github:sircam-html/ut4-community-launcher
./result/bin/ut4-community-launcher
```

To install it permanently into your user profile (including the `.desktop` entry):

```bash
nix profile install github:sircam-html/ut4-community-launcher
```

## Notes

- **Native launcher, Wine game:** The launcher UI runs natively on Linux via `appimageTools.wrapType2`, while Unreal Tournament 4 itself runs as a Win64 binary inside your Wine/Proton prefix.
- **Bundled runtime dependencies:** The wrapper explicitly injects `webkitgtk_4_1`, `gtk3`, `libsoup_3`, `glib-networking`, `openssl`, `libsecret`, `libgpg-error`, and `libgcrypt` into the FHS environment so the AppImage launches cleanly on NixOS.
- **No telemetry:** Updates fetched by the launcher are cryptographically signed, and the app sends no telemetry.
