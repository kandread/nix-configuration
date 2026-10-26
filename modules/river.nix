{ inputs, den, ... }:
{
  den.aspects.river = {

    nixos = { pkgs, ... }:
      let
        # River, kwm, kwim and argen don't build with zig 0.17 yet (build.zig
        # uses b.build_root, removed in 0.17), so they get zig 0.16. Scoped to
        # the river-next module rather than a global overlay, so other zig
        # packages from nixpkgs stay cached.
        zig16 = pkgs: pkgs.extend (final: prev: { zig = prev.zig_0_16; });
        river-next-module = { config, lib, pkgs, ... }:
          import "${inputs.river-next}/river-module.nix" { inherit config lib; pkgs = zig16 pkgs; };

        argen = pkgs.callPackage "${inputs.river-next}/window-managers/argen/package.nix" { zig = pkgs.zig_0_16; };

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
        imports = [ river-next-module ];

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
