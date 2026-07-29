{ ... }:
{
  den.aspects.waybar = {
    homeManager = { ... }: {
      programs.waybar = {
        enable = true;

        settings = {
          mainBar = {
            layer = "top";
            position = "top";
            height = 30;

            modules-left = [ "sway/workspaces" "sway/mode" ];
            modules-center = [ "clock" ];
            modules-right = [ "pulseaudio" "network" "battery" "tray" ];

            "sway/workspaces" = {
              disable-scroll = true;
            };

            clock = {
              format = "{:%Y-%m-%d %H:%M}";
            };

            battery = {
              format = "{capacity}% {icon}";
              format-icons = [ "" "" "" "" "" ];
              format-charging = "{capacity}% ";
            };

            network = {
              format-wifi = "  {essid} ({signalStrength}%)";
              format-ethernet = "Wired";
              format-disconnected = "Disconnected";
            };

            pulseaudio = {
              format = "{volume}% {icon}";
              format-muted = "Muted";
              format-icons = {
                default = [ "" "" "" ];
              };
              on-click = "pavucontrol";
            };

            tray = {
              spacing = 10;
            };
          };
        };

        # Colors/fonts come from stylix (see theming.nix), which derives a
        # base16 palette from the sway wallpaper and themes waybar automatically.
      };
    };
  };
}
