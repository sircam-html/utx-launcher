{
  description = "UT4 Community Launcher (NetcodePlus) 1.9.0 on NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        pname = "ut4-community-launcher";
        version = "1.9.0";

        src = pkgs.fetchurl {
          url = "https:/" + "/github.com" + "/jmortley/netcodeplus-launcher/releases/download/v1.9.0/UT4-Community-Launcher-x86_64.AppImage";
          hash = "sha256-xRGdy6t5A2bSDEl4/yFkM8TiUj1uBxo4859hSKgTWu8=";
        };

        appimageContents = pkgs.appimageTools.extract {
          inherit pname version src;
        };

        winePkg = pkgs.wineWow64Packages.staging;
        dxvk = pkgs.dxvk;

        unwrappedLauncher = pkgs.appimageTools.wrapType2 {
          inherit pname version src;

          extraPkgs = pkgs: with pkgs; [
            # UI & Tauri dependencies
            libsecret
            libgpg-error
            libgcrypt
            webkitgtk_4_1
            gtk3
            libsoup_3
            openssl
            glib-networking
            xdg-utils

            # Game execution, Graphics (Vulkan/DXVK) & Audio
            winePkg
            winetricks
            dxvk
            vulkan-loader
            vulkan-tools
            mesa
            libglvnd
            libpulseaudio
            alsa-lib
            coreutils
            bash
          ];

          extraInstallCommands = ''
            install -m 444 -D ${appimageContents}/*.desktop $out/share/applications/${pname}.desktop || true
            substituteInPlace $out/share/applications/${pname}.desktop \
              --replace-quiet 'Exec=AppRun' 'Exec=${pname}' || true
          '';

          meta = with pkgs.lib; {
            description = "UT4 Community Launcher for NetcodePlus";
            platforms = [ "x86_64-linux" ];
          };
        };

        launcher = pkgs.symlinkJoin {
          name = "${pname}-${version}";
          paths = [ unwrappedLauncher ];
          nativeBuildInputs = [ pkgs.makeWrapper ];
          # The launcher asks Wine for native DXVK DLLs but never installs them, so we
          # do it on first run. We also force NVIDIA GL/Vulkan: otherwise the FHS
          # wrapper can pick Mesa llvmpipe (software) and the game crawls.
          postBuild = ''
            wrapProgram $out/bin/${pname} \
              --run 'mkdir -p "$HOME/.local/share/ut4-wine-runner/bin" "$HOME/.local/share/ut4-wine-prefix"' \
              --run 'ln -sf ${winePkg}/bin/* "$HOME/.local/share/ut4-wine-runner/bin/"' \
              --run 'export WINEPREFIX="''${WINEPREFIX:-$HOME/.local/share/ut4-wine-prefix}"' \
              --run 'if [ ! -f "$WINEPREFIX/.nix-dxvk-installed" ]; then mkdir -p "$WINEPREFIX/drive_c/windows/system32" "$WINEPREFIX/drive_c/windows/SysWOW64"; for dll in ${dxvk.dxvk64}/bin/*.dll; do f="$(basename "$dll")"; if [ -f "$WINEPREFIX/drive_c/windows/system32/$f" ] && [ ! -f "$WINEPREFIX/drive_c/windows/system32/$f.bak" ]; then mv "$WINEPREFIX/drive_c/windows/system32/$f" "$WINEPREFIX/drive_c/windows/system32/$f.bak"; fi; cp -f "$dll" "$WINEPREFIX/drive_c/windows/system32/$f"; done; for dll in ${dxvk.dxvk32}/bin/*.dll; do f="$(basename "$dll")"; if [ -f "$WINEPREFIX/drive_c/windows/SysWOW64/$f" ] && [ ! -f "$WINEPREFIX/drive_c/windows/SysWOW64/$f.bak" ]; then mv "$WINEPREFIX/drive_c/windows/SysWOW64/$f" "$WINEPREFIX/drive_c/windows/SysWOW64/$f.bak"; fi; cp -f "$dll" "$WINEPREFIX/drive_c/windows/SysWOW64/$f"; done; touch "$WINEPREFIX/.nix-dxvk-installed"; fi' \
              --run 'export WINEDLLOVERRIDES="''${WINEDLLOVERRIDES:-d3d11,d3d10core,dxgi,d3d9=n,b}"' \
              --run 'export __GLX_VENDOR_LIBRARY_NAME="''${__GLX_VENDOR_LIBRARY_NAME:-nvidia}"' \
              --run 'export VK_ICD_FILENAMES="''${VK_ICD_FILENAMES:-/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.json}"' \
              --run 'export WINEFSYNC="''${WINEFSYNC:-1}"' \
              --run 'export WINEDEBUG="''${WINEDEBUG:--all}"'
          '';
        };
      in
      {
        packages.default = launcher;

        apps.default = {
          type = "app";
          program = "${launcher}/bin/${pname}";
        };
      });
}
