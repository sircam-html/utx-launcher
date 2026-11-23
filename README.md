# Nix Flake for UT4 Community Launcher (NetcodePlus)

Nix flake para ejecutar la build oficial de Linux del [UT4 Community Launcher](https://github.com) para **Unreal Tournament 4** en NixOS. Utiliza `appimageTools` para envolver el AppImage nativo y sus dependencias (WebKit, GTK, GPG) sin necesidad de Wine para el launcher.

## Ejecución

```bash
nix run github:sircam-html/utx-launcher
```

### Requisitos

- `x86_64-linux` con Flakes habilitados.
- Instalación previa de **Unreal Tournament 4** (ejecutándose en un prefijo de Wine, Proton o Lutris).

### Primer uso y actualización

1. Ejecuta el comando y apunta el launcher a tu directorio de instalación de UT4 para mantener actualizados los plugins y paks.
2. Para actualizar el launcher a una nueva versión de upstream, modifica `version` y el hash correspondiente en `flake.nix`.

## Instalación local

Para compilarlo localmente o instalarlo en tu perfil:

```bash
nix build github:sircam-html/utx-launcher
nix profile install github:sircam-html/utx-launcher
```

*Nota: La interfaz del launcher corre de forma nativa en Linux, mientras que Unreal Tournament 4 se ejecuta mediante Wine/Proton.*
