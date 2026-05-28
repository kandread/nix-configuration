{ inputs, ... }:
{
  den.aspects.wayland = {
    nixos = { ... }: {
      imports = [ inputs.dms.nixosModules.dank-material-shell ];
      programs.dank-material-shell.enable = true;
      security.polkit.enable = true;
      xdg.portal = {
        enable = true;
        wlr.enable = true;
      };
    };
    homeManager = { pkgs, ... }: {
      imports = [ inputs.dms.homeModules.dank-material-shell ];

      programs.dank-material-shell = {
        enable = true;
        systemd.enable = true;
        settings = {
          compositor = "mango";
        };
      };

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
        enable = true;
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
