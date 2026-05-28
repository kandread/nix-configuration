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
        enable = true;
        systemd.target = "wayland-session.target";
      };
      programs.niri.enable = true;
    };
    homeManager = { pkgs, ... }: {

      programs.fuzzel = {
        enable = true;
        settings = {
          main = {
            terminal = "${pkgs.kitty}/bin/kitty";
            icon-theme = "Adwaita";
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
        };
      };

      services.kanshi = {
        enable = false;
        settings = [
          {
            profile.name = "default";
            profile.outputs = [
              {
                criteria = "eDP-1";
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
      ];
    };
  };
}
