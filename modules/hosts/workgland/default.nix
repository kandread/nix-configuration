{ den, ... }:
{
  den.aspects.workgland = {

    includes = [
      den.aspects.searx
      den.aspects.squeezelite
    ];

    nixos = { pkgs, ... }: {
      networking.hostName = "workgland";

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.loader.efi.efiSysMountPoint = "/boot/efi";
      boot.kernelPackages = pkgs.linuxPackages_latest;

      hardware.enableRedistributableFirmware = true;
      hardware.enableAllFirmware = true;

      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
      };

      services.openssh.enable = true;

      services.xserver.enable = true;
      services.displayManager.gdm.enable = true;
      services.desktopManager.gnome.enable = true;
      services.xserver.xkb = {
        layout = "us";
        variant = "";
      };

      xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];

      services.printing.enable = true;
      services.printing.drivers = with pkgs; [ cups-toshiba-estudio ];

      # Nvidia
      hardware.graphics.enable = true;
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.nvidia = {
        # Modesetting is required.
        modesetting.enable = true;
        # The open source kernel module is still alpha-quality for this GPU.
        open = false;
        nvidiaSettings = true;
      };
    };
  };
}
