{ den, inputs, ... }:
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
      hardware.enableRedistributableFirmware = true;
      hardware.enableAllFirmware = true;
      imports = [ inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-13th-gen ];
      services.xserver.enable = true;
      services.displayManager.gdm.enable = true;
      services.desktopManager.gnome = {
        enable = true;
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
