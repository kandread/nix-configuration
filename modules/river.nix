{ inputs, den, ... }:
{
  den.aspects.river = {

    nixos = { pkgs, ... }:
      let
        argen = pkgs.callPackage "${inputs.river-next}/window-managers/argen/package.nix" { };

        ironbar-cu1 = pkgs.writeShellApplication {
          name = "ironbar-cu1";
          runtimeInputs = [ argen pkgs.jq pkgs.ironbar ];
          text = ''
            context=$(argenctl context list --json | jq -r '.[] | select(.current == true) | .name')

            line="[[$context]]"

            ironbar var set custom-status-1 "$line" > /dev/null
          '';
        };
      in
      {
        imports = [ "${inputs.river-next}/river-module.nix" ];

        environment.systemPackages = [
          pkgs.python3
          pkgs.ironbar
          ironbar-cu1
        ];

        programs.river-next = {
          enable = true;
          windowManagers = [ "kwm" "argen" ];
        };
      };
  };
}
