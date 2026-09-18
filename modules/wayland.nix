{ inputs, ... }:
{
  den.aspects.wayland = {
    nixos = { ... }: {
    #   security.polkit.enable = true;
      xdg.portal = {
        enable = true;
        wlr.enable = true;
        };
      programs.dms-shell = {
        enable = false;
        systemd.target = "wayland-session.target";
      };
      programs.mango.enable = true;
    };
    homeManager = { pkgs, lib, ... }: {

      programs.fuzzel = {
        enable = true;
        settings = {
          main = {
            terminal = "${pkgs.kitty}/bin/kitty";
            # icon-theme = "Adwaita";
            icons-enabled = true;
            width = 40;
            lines = 12;
            horizontal-pad = 16;
            vertical-pad = 8;
            inner-pad = 4;
          };
          border = {
            width = 2;
            radius = 6;
          };
          colors = lib.mkForce {
          background = "161616ff";
          text = "ffffffff";
          match = "ee5396ff";
          selection-match = "ee5396ff";
          selection = "262626ff";
          selection-text = "33b1ffff";
          border = "525252ff";
            };
        };
      };

      # kanshi matches a profile only when it accounts for *exactly* the
      # connected outputs: every output in the profile must be present, and
      # every connected output must be claimed by the profile. So one profile
      # per hardware configuration, not one profile listing every output that
      # might ever appear — that last form matches nothing unless everything
      # is plugged in at once.
      #
      # This aspect reaches both hosts through kandread, so minigland (a
      # desktop, DP-1 only) needs its own profile alongside x1gland's.
      services.kanshi = {
        enable = true;
        settings = [
          {
            profile.name = "x1gland-docked";
            profile.outputs = [
              {
                criteria = "eDP-1";
                status = "enable";
                scale = 1.5;
                position = "0,0";
              }
              {
                criteria = "DP-1";
                status = "enable";
                scale = 1.5;
                position = "1280,0";
              }
            ];
          }
          {
            profile.name = "x1gland-laptop";
            profile.outputs = [
              {
                criteria = "eDP-1";
                status = "enable";
                scale = 1.5;
              }
            ];
          }
          {
            profile.name = "minigland-desktop";
            profile.outputs = [
              {
                criteria = "DP-1";
                status = "enable";
                scale = 1.5;
              }
            ];
          }
        ];
      };

      home.packages = with pkgs; [
        wl-clipboard
        wlr-randr
        grim
        slurp
        sway-contrib.grimshot
	swaybg
        wev
      ];
    };
  };
}
