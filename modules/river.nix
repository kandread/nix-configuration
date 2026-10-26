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

        # oxbow is a river window manager written in OCaml. It needs river
        # 0.4.6+, so it runs on nixpkgs' river rather than the river-next
        # module's (which only knows the WMs in its fixed enum). The session
        # mirrors the module's init script: import the environment, start
        # river-session.target (portals), then exec the WM.
        oxbow = inputs.oxbow.packages.${pkgs.stdenv.hostPlatform.system}.default;
        oxbow-init = pkgs.writeShellScript "river-oxbow-init" ''
          export XDG_CURRENT_DESKTOP=river

          ${pkgs.systemd}/bin/systemctl --user import-environment \
            WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_RUNTIME_DIR DISPLAY
          ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd \
            WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_RUNTIME_DIR DISPLAY

          ${pkgs.systemd}/bin/systemctl --user start river-session.target

          exec ${oxbow}/bin/oxbow
        '';
        oxbow-launcher = pkgs.writeShellScript "river-oxbow-launcher" ''
          exec ${pkgs.dbus}/bin/dbus-run-session -- ${pkgs.river}/bin/river -c ${oxbow-init}
        '';
        oxbow-session = pkgs.writeTextFile {
          name = "river-oxbow-session";
          destination = "/share/wayland-sessions/river-oxbow.desktop";
          text = ''
            [Desktop Entry]
            Name=River (oxbow)
            Type=Application
            Comment=Launch River with oxbow as window manager.
            Exec=${oxbow-launcher}
          '';
          passthru.providedSessions = [ "river-oxbow" ];
        };
      in
      {
        imports = [ river-next-module ];

        services.displayManager.sessionPackages = [ oxbow-session ];

        environment.systemPackages = [
          pkgs.python3
          oxbow
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
