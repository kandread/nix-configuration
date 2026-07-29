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

          output."*" = {
            bg = "${../assets/clay-banks-u27Rrbs9Dwc-unsplash.jpg} fill";
            scale = "1.5";
          };

          input = {
            "type:touchpad" = {
              natural_scroll = "enabled";
            };
            "type:pointer" = {
              natural_scroll = "enabled";
            };
          };

          gaps = {
            inner = 10;
            outer = 5;
          };

          # waybar replaces the native swaybar
          bars = [ ];

          startup = [
            { command = "waybar"; }
          ];

          assigns = {
            "1" = [
              { class = "^Emacs$"; }
            ];
            "2" = [
              { app_id = "^firefox$"; }
              { class = "^Firefox$"; }
            ];
          };

          workspaceAutoBackAndForth = true;
        };
      };
    };
  };
}
