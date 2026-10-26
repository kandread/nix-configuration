{ ... }:
{
  den.aspects.waybar = {
    homeManager = { ... }:
      let
        mainBar = {
          layer = "top";
          position = "top";
          height = 30;

          modules-left = [ "sway/workspaces" "sway/mode" ];
          modules-center = [ ];
          modules-right = [ "pulseaudio" "network" "cpu" "memory" "battery" "tray" "clock" ];

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
      in
      {
        # dwl gets its own config file, started from dwl's startup script
        # (dwl.nix): the same bar with dwl's tags, layout symbol and focused
        # window title (dwl-ipc, from dwl's ipc patch) in place of the sway
        # modules. The layout indicator is a second dwl/window instance that
        # shows only {layout} ([]=, ><>, [M]/[n], [D]/[Dn]).
        xdg.configFile."waybar/dwl.json".text = builtins.toJSON (
          removeAttrs mainBar [ "sway/workspaces" ] // {
            modules-left = [ "dwl/tags" "dwl/window#layout" "dwl/window" ];
            # Fixed 4-character width, centered: left alone, the label
            # keeps the widest width it has ever had and right-aligns.
            "dwl/window#layout" = {
              format = "{layout}";
              min-length = 4;
              max-length = 4;
              align = 0.5;
            };
          }
        );

        programs.waybar = {
          enable = true;

          settings = { inherit mainBar; };

          # stylix's waybar target is disabled (theming.nix) so this owns fonts
          # outright instead of merging with the generated theme.
          style = ''
            * {
              font-family: "JetBrainsMono Nerd Font";
              font-size: 14px;
            }

            #workspaces button,
            #tags button {
              padding: 0 8px;
            }

            #workspaces button.focused,
            #workspaces button.active,
            #tags button.focused {
              background-color: #3b82f6;
              color: #ffffff;
              border-radius: 6px;
            }

            /* waybar's dwl/tags has no hide-vacant option and GTK CSS has no
               display:none, so collapse unoccupied tags (unless focused or
               urgent) to nothing instead. Not ".empty": waybar 0.15 adds it
               to every tag (it tests clients & TAG_INACTIVE, which is 0).
               The label needs its own rule because "*" above sets its size
               directly, so font-size on the button never reaches it. */
            #tags button:not(.occupied):not(.focused):not(.urgent),
            #tags button:not(.occupied):not(.focused):not(.urgent) label {
              padding: 0;
              margin: 0;
              min-width: 0;
              min-height: 0;
              border: none;
              font-size: 0;
            }

            #tags button.urgent {
              background-color: #40bfff;
              color: #202126;
              border-radius: 6px;
            }

            #window {
              padding: 0 10px;
            }

            #window.layout {
              background-color: #7c3aed;
              color: #ffffff;
              border-radius: 6px;
              padding: 0 6px;
              margin: 0 4px;
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

            #battery {
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

            #clock {
              padding: 0 10px;
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
