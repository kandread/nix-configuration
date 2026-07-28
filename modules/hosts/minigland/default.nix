{ den, ... }:
{
  den.aspects.minigland = {

    includes = [
      den.aspects.squeezelite
    ];

    nixos = { pkgs, ... }: {
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.kernelPackages = pkgs.linuxPackages_latest;

      hardware.enableRedistributableFirmware = true;
      hardware.enableAllFirmware = true;

      networking.hostName = "minigland";
      networking.firewall = {
        enable = true;
        allowedTCPPorts = [ 9000 6680 ];
      };

      services.xserver.enable = true;
      services.displayManager.gdm.enable = true;
      services.desktopManager.gnome.enable = true;

      services.openssh.enable = true;

      services.slimserver.enable = true;

      services.jellyfin = {
        enable = true;
        user = "kandread";
        group = "video";
        openFirewall = true;
      };

      services.printing.drivers = with pkgs; [ canon-cups-ufr2 ];

      fileSystems."/mnt/music" = {
        device = "/dev/disk/by-uuid/6200-8404";
        fsType = "auto";
        options = [ "nofail" ];
      };
    };
  };
}
