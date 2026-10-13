{ ... }:
{
  # dwm-like bar for dwl. It is launched by dwl itself (`dwl -s somebar`, see
  # modules/dwl.nix) so it can read dwl's state from stdin.
  den.aspects.somebar = {
    nixos = { pkgs, ... }: {
      environment.systemPackages = [ pkgs.somebar ];
    };
  };
}
