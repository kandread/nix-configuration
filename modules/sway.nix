{ ... }:
{
  den.aspects.sway = {
    nixos = { ... }: {
      programs.sway.enable = true;
    };
    homeManager = { config, ... }: {
      wayland.windowManager.sway = {
        enable = true;
        wrapperFeatures.gtk = true;

        config = {
          modifier = "Mod4";
          terminal = "kitty";
          menu = "fuzzel";

          # Same font role waybar uses (stylix's waybar target defaults to
          # monospace) so window titlebars visually match the bar.
          fonts = {
            names = [ config.stylix.fonts.monospace.name ];
            size = config.stylix.fonts.sizes.desktop + 0.0;
          };

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
            inner = 20;
            outer = 10;
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

          # Window border/background colors (stylix's sway target is disabled
          # in theming.nix, so this is fully manual). Pulled from the same
          # stylix base16 palette so it still tracks theme changes; focused
          # background uses base02 (the "selection" role) instead of the
          # near-black base00 everything else uses.
          colors =
            with config.lib.stylix.colors.withHashtag;
            let
              text = base05;
              indicator = base0B;
              background = base00;
            in
            {
              inherit background;
              focused = {
                background = base02;
                border = base0D;
                childBorder = base0D;
                inherit indicator text;
              };
              focusedInactive = {
                inherit background indicator text;
                border = base03;
                childBorder = base03;
              };
              unfocused = {
                inherit background indicator text;
                border = base03;
                childBorder = base03;
              };
              urgent = {
                inherit background indicator text;
                border = base08;
                childBorder = base08;
              };
              placeholder = {
                inherit background indicator text;
                border = base03;
                childBorder = base03;
              };
            };

          window.commands = [
            {
              command = "floating enable";
              criteria = { title = "^Picture-in-Picture$"; };
            }
          ];
        };

        # Using extraConfig (rather than config.keybindings) here since setting
        # config.keybindings at all replaces the module's entire default
        # keybinding set instead of merging with it.
        extraConfig = ''
          bindsym Mod4+Shift+s sticky toggle
        '';
      };
    };
  };
}
