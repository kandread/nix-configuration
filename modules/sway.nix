{ ... }:
{
  den.aspects.sway = {
    nixos = { ... }: {
      programs.sway.enable = true;
    };
    homeManager = { ... }: {
      wayland.windowManager.sway = {
        enable = true;
        wrapperFeatures.gtk = true;

        config = {
          modifier = "Mod4";
          terminal = "kitty";
          menu = "fuzzel";

          output."*".bg = "${../assets/clay-banks-u27Rrbs9Dwc-unsplash.jpg} fill";
        };
      };
    };
  };
}
