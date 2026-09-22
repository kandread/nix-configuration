{ ... }:
{
  den.aspects.workgland = {
    nixos = { config, lib, modulesPath, ... }: {
      imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

      boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "ahci" "usbhid" "usb_storage" "sd_mod" ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "kvm-amd" ];
      boot.extraModulePackages = [ ];

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/ada49125-7156-4503-9366-1aa390518cdc";
        fsType = "ext4";
      };

      fileSystems."/boot/efi" = {
        device = "/dev/disk/by-uuid/A8CC-258E";
        fsType = "vfat";
      };

      swapDevices = [ ];

      networking.useDHCP = lib.mkDefault true;

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
  };
}
