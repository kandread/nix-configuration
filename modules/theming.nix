{ inputs, ... }:
{
  den.aspects.theming = {
    nixos = { ... }: {
      imports = [ inputs.stylix.nixosModules.stylix ];
    };
    homeManager = { pkgs, lib, ... }: {
      imports = [ inputs.stylix.homeModules.stylix ];
      gtk.gtk4.theme = lib.mkForce null;
      stylix = {
        enable = true;
        image = ../assets/clay-banks-u27Rrbs9Dwc-unsplash.jpg;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/gigavolt.yaml";
        polarity = "dark";
        targets = {
          # kitty, sway, and waybar are hand-configured (kitty.nix, sway.nix,
          # waybar.nix) — don't let stylix silently fight those settings.
          kitty.enable = false;
          sway.enable = false;
          waybar.enable = false;
          firefox.profileNames = [ "kandread" ];
        };
        cursor = {
          name = "Bibata-Modern-Classic";
          package = pkgs.bibata-cursors;
          size = 24;
        };
      };
    };
  };
}
