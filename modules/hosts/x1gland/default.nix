{ den, pkgs, ... }:
{
  den.aspects.x1gland = {
    nixos = { pkgs, ... }: {
      networking.hostName = "x1gland";
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.kernelPackages = pkgs.linuxPackages_latest;
      boot.kernelParams = [
        "mem_sleep_default=s2idle"
        "intel_pstate=active"
      ];
      services.xserver.enable = true;
      services.displayManager.gdm.enable = true;
      services.desktopManager.gnome = {
        enable = true;
        extraGSettingsOverrides = ''
          [org.gnome.mutter]
          experimental-features=['scale-monitor-framebuffer', 'xwayland-native-scaling']
        '';
      };
      services.xserver.xkb = {
        layout = "us";
        variant = "";
      };
      services.printing.enable = true;
      programs.firefox.enable = true;
      services.thermald = {
        enable = true;
        ignoreCpuidCheck = true;
      };
      services.power-profiles-daemon.enable = true;
      services.fprintd.enable = true;
    };
  };
}
