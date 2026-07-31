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
            modules-right = [ "pulseaudio" "network" "cpu" "memory" "battery" "tray" ];

            "sway/workspaces" = {
              disable-scroll = true;
            };

            cpu = {
              interval = 5;
              format = " {usage}%";
            };

            memory = {
              interval = 5;
              format = " {used:0.1f}G";
            };

            clock = {
              format = "{:%Y-%m-%d %H:%M}";
            };

            battery = {
              format = "{capacity}% {icon}";
              format-icons = [ "" "" "" "" "" ];
              format-charging = "{capacity}% ";
            };

            network = {
              format-wifi = " {essid} ({signalStrength}%)";
              format-ethernet = "Wired";
              format-disconnected = "Disconnected";
            };

            pulseaudio = {
              format = "{volume}% {icon}";
              format-muted = "Muted";
              format-icons = {
                default = [ "" "" "" ];
              };
              on-click = "pavucontrol";
            };

            tray = {
              spacing = 10;
            };
          };
        };

        # stylix's waybar target is disabled (theming.nix) so this owns fonts
        # outright instead of merging with the generated theme.
        style = ''
          * {
            font-family: "JetBrainsMono Nerd Font";
            font-size: 14px;
          }

          #workspaces button {
            padding: 0 8px;
          }

          #workspaces button.focused,
          #workspaces button.active {
            background-color: #3b82f6;
            color: #ffffff;
            border-radius: 6px;
          }

          #pulseaudio {
            color: #a6e3a1;
            padding: 0 10px;
            margin: 0 4px;
          }

          #network {
            color: #f9e2af;
            padding: 0 10px;
            margin: 0 4px;
          }

          #cpu {
            color: #cba6f7;
            padding: 0 10px;
            margin: 0 4px;
          }

          #memory {
            color: #94e2d5;
            padding: 0 10px;
            margin: 0 4px;
          }

          #tray {
            padding: 0 10px;
            margin: 0 4px;
          }
        '';
      };
    };
  };
}
