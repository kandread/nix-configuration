{ inputs, ... }:
{
  den.aspects.nix-ld = {
    nixos = { ... }: {
      imports = [ inputs.nix-ld.nixosModules.nix-ld ];
      programs.nix-ld.enable = true;
    };
  };
}
