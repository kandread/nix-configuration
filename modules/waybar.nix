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

        # Palette pulled from the sway wallpaper (clay-banks-u27Rrbs9Dwc-unsplash.jpg):
        # dark charcoal background, muted grey-green text, warm tan accent
        # (matching the focuscolor used in mango.nix for cross-WM consistency).
        style = ''
          * {
            font-family: monospace;
            font-size: 13px;
            min-height: 0;
          }

          window#waybar {
            background-color: rgba(29, 34, 33, 0.9);
            color: #9fa09a;
          }

          #workspaces button {
            padding: 0 8px;
            color: #9fa09a;
            background-color: transparent;
          }

          #workspaces button.focused {
            background-color: #c9b890;
            color: #1d2221;
          }

          #workspaces button.urgent {
            background-color: #ad401f;
            color: #1d2221;
          }

          #clock,
          #battery,
          #network,
          #pulseaudio,
          #tray,
          #mode {
            padding: 0 10px;
            color: #9fa09a;
          }

          #battery.charging {
            color: #c9b890;
          }

          #battery.warning:not(.charging) {
            color: #ad401f;
          }
        '';
      };
    };
  };
}
