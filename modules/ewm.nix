{ inputs, ... }:
{
  den.aspects.ewm = {
    nixos = { ... }: {
      imports = [ inputs.ewm.nixosModules.default ];
      programs.ewm.enable = true;
    };
  };
}
