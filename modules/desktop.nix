{ inputs, ... }:
{
  den.aspects.desktop = {
    nixos = { config, lib, ... }: {
      services.xserver.dpi = 144;
      services.xserver.windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
        enableConfiguredRecompile = true;
        extraPackages = hpkgs: [
          hpkgs.xmobar
          hpkgs.xmonad-extras
          hpkgs.xmonad-contrib
        ];
      };
    };
    homeManager = { pkgs, ... }: {
      programs.xmobar = {
        enable = true;
      };
      home.packages = with pkgs; [
        xmobar
        flameshot
        xclip
        xdotool
        playerctl
        brightnessctl
        pavucontrol
        xsetroot
        feh
        man-db
        dmenu
      ];
    };
  };
}
