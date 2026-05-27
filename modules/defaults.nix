{ lib, den, ... }:
{
  den.default.nixos.system.stateVersion = "25.11";
  den.default.nixos.nixpkgs.overlays = [ inputs.nur.overlays.default ];
  den.default.homeManager.home.stateVersion = "25.11";
  den.default.homeManager.nixpkgs.overlays = [ inputs.nur.overlays.default ];
  den.schema.user.classes = lib.mkDefault [ "homeManager" ];
  den.default.nixos.nix.settings = {
    sandbox = "relaxed";
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [ "https://nix-community.cachix.org" ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  den.default.includes = [
    den.aspects.fonts
    den.aspects.tailscale
    den.aspects.audio
    den.aspects.networking
    den.aspects.locale
    den.aspects.sops
    (den.batteries.unfree [ 
	"zoom" 
	"joypixels" 
	"claude-code" 
	"broadcom-bt-firmware" 
	"b43-firmware" 
	"xone-dongle-firmware"
	"facetimehd-calibration"
	"facetimehd-firmware" ])
    den.batteries.define-user
  ];
}
