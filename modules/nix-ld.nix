{ inputs, ... }:
{
  den.aspects.nix-ld = {
    nixos = { ... }: {
       programs.nix-ld.enable = true;
    };
  };
}
