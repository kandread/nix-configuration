{ inputs, ... }:
{
  den.aspects.desktop = {
    nixos = { ... }: {
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
    };
  };
}
