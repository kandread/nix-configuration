{ ... }:
{
  # Bar for dwl. It talks to dwl over the dwl-ipc protocol (ipc patch in
  # modules/dwl.nix) and is launched from dwl's startup script there.
  den.aspects.dwlb = {
    nixos = { pkgs, ... }: {
      environment.systemPackages = [ pkgs.dwlb ];
    };
  };
}
