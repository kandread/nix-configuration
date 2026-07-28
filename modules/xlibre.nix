{ inputs, ... }:
{
  den.aspects.xlibre = {
    nixos = { ... }: {
      imports = [
        inputs.xlibre-overlay.nixosModules.overlay-xlibre-xserver
        inputs.xlibre-overlay.nixosModules.overlay-all-xlibre-drivers
      ];
    };
  };
}
