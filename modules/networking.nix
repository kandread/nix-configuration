{ ... }:
{
  den.aspects.networking = {
    nixos = { ... }: {
      networking.networkmanager.enable = true;
    };

    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        gp-saml-gui
      ];
    };
  };
}
