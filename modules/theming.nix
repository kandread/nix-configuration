{ inputs, ... }:
{
  den.aspects.theming = {
    nixos = { ... }: {
      imports = [ inputs.stylix.nixosModules.stylix ];
    };
    homeManager = { pkgs, ... }: {
      imports = [ inputs.stylix.homeModules.stylix ];
      gtk.gtk4.theme = null;
      stylix = {
        enable = true;
        # base16Scheme = "${pkgs.base16-schemes}/share/themes/gigavolt.yaml";
        image = ../assets/andre-benz-cXU6tNxhub0-unsplash.jpg;
        polarity = "dark";
        targets = {
          kitty.fonts.enable = false;
          firefox.profileNames = [ "kandread" ];
        };
      };
    };
  };
}
