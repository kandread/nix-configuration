{ inputs, den, ... }:
{
  den.aspects.river = {

    nixos = { pkgs, ... }: {
      imports = [ "${inputs.river-next}/river-module.nix" ];

      environment.systemPackages = with pkgs; [
        python3
        ironbar
      ];

      programs.river-next = {
        enable = true;
        windowManagers = [ "kwm" "argen" ];
      };
    };
  };
}
