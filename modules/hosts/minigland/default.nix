{ den, ... }:
{
  den.aspects.minigland = {

    includes = [
      den.aspects.squeezelite
    ];

    nixos = { pkgs, ... }: {
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      networking.hostName = "minigland";
      networking.firewall = {
        enable = true;
        allowedTCPPorts = [ 9000 6680 ];
      };

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
