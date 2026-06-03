{ ... }:
{
  den.aspects.qtile = {
    includes = [ den.aspects.xserver ];
    nixos = { pkgs, ... }: {
      services.xserver.windowManager.qtile = {
        enable = true;
        extraPackages = python3Packages: with python3Packages; [
          qtile-extras
          psutil
          dbus-python
          pygobject3
        ];
      };
    };
  };
}
