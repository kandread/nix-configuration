{ den, lib, ... }:
{
  den.aspects.minigland.nixos = { config, lib, ... }: {
    boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usbhid" "usb_storage" "sd_mod" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-amd" ];
    boot.extraModulePackages = [ ];

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/27c92053-d055-430e-8b94-a438147e7004";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

    fileSystems."/home" = {
      device = "/dev/disk/by-uuid/27c92053-d055-430e-8b94-a438147e7004";
      fsType = "btrfs";
      options = [ "subvol=@home" ];
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/6061-C87E";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

    swapDevices = [ ];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.enableRedistributableFirmware = true;
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
