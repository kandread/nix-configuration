{ ... }:
{
  den.aspects.dwl = {
    nixos = { pkgs, lib, ... }:
      let
        # Stock config.def.h with three edits (applied after the patches): Super instead of Alt as the
        # modifier, natural scrolling, and a 1.5 scale on every output (the
        # catch-all monitor rule). Patching in place avoids carrying a
        # full config.h copy that would go stale on dwl updates.
        dwl = pkgs.dwl.overrideAttrs (old: {
          # client-opacity-focus, ported to 0.9 (upstream's patch targets a
          # different base). Super+Ctrl+j/k adjust unfocused opacity,
          # Super+Ctrl+Shift+J/K the focused one. gaps is our own small patch
          # (gappx in config.def.h, default 8).
          patches = (old.patches or [ ]) ++ [
            # dwl-ipc-unstable-v2 for waybar's dwl modules (dwl-patches, v0.9). Listed first
            # (verified to apply in this order; the rest apply with offsets).
            ./dwl/ipc.patch
            ./dwl/client-opacity-focus.patch
            ./dwl/gaps.patch
            # Super+BackSpace (rebound in postPatch from the patch's Super+s):
            # focus the previously focused window. From dwl-patches, applies
            # to 0.9 with offsets.
            ./dwl/swapfocus.patch
            # Super+arrows move, Super+Shift+arrows resize floating windows
            # (dwl-patches).
            ./dwl/moveresizekb.patch
            # Super+x: center the focused floating window. dwl-patches'
            # version no longer applies to 0.9, so this is a trimmed rewrite.
            ./dwl/movecenter.patch
          ];
          postPatch = (old.postPatch or "") + ''
            sed -i \
              -e 's/^#define MODKEY .*/#define MODKEY WLR_MODIFIER_LOGO/' \
              -e 's/natural_scrolling = 0;/natural_scrolling = 1;/' \
              -e 's/{ NULL,       0.55f, 1,      1, /{ NULL,       0.55f, 1,      1.5f,/' \
              -e 's/XKB_KEY_s, \( *\)swapfocus,/XKB_KEY_BackSpace, swapfocus,/' \
              -e 's|"wmenu-run", NULL|${menuArgs}, NULL|' \
              config.def.h
          '';
        });

        # bemenu-run as the launcher: centered, vertical list, colors from the
        # stylix gigavolt palette (theming.nix). stylix lives in home-manager,
        # so the hex values are copied from the scheme file rather than read
        # from config.lib.stylix.
        menuArgs = lib.concatMapStringsSep ", " (a: "\"${a}\"") [
          "${pkgs.bemenu}/bin/bemenu-run"
          "-i" "-c" "-l" "10" "-W" "0.35" "-B" "2" "-R" "8"
          "--fn" "MesloLGS Nerd Font 12"
          "--bdr" "#40bfff"
          "--tb" "#202126" "--tf" "#40bfff"
          "--fb" "#202126" "--ff" "#e9e7e1"
          "--nb" "#202126" "--nf" "#e9e7e1"
          "--ab" "#202126" "--af" "#e9e7e1"
          "--hb" "#5a576e" "--hf" "#f2fbff"
          "--sb" "#5a576e" "--sf" "#f2fbff"
          "--cb" "#e9e7e1" "--cf" "#202126"
          "--fbb" "#202126" "--fbf" "#e9e7e1"
        ];

        # dwl's `-s` command runs once the compositor socket exists, so this
        # takes the place of the autostart patch: background things first,
        # then exec the bar. The bar is waybar with the dwl config written by
        # the waybar aspect (waybar.nix); its dwl/tags and dwl/window modules
        # talk to dwl over the ipc patch.
        dwl-startup = pkgs.writeShellScript "dwl-startup" ''
          ${pkgs.swaybg}/bin/swaybg -i ${../assets/1r1kk9qi00961.png} -m fill &
          exec ${pkgs.waybar}/bin/waybar -c "$HOME/.config/waybar/dwl.json"
        '';

        dwl-session = pkgs.writeShellScriptBin "dwl-session" ''
          exec ${dwl}/bin/dwl -s ${dwl-startup}
        '';

        # GDM finds sessions through passthru.providedSessions. The desktop
        # file shipped with pkgs.dwl runs bare `dwl`, so this replaces it to
        # run the wrapper above.
        dwl-session-file = pkgs.writeTextFile {
          name = "dwl-session-file";
          destination = "/share/wayland-sessions/dwl.desktop";
          text = ''
            [Desktop Entry]
            Name=dwl
            Comment=dwm for Wayland
            Exec=${dwl-session}/bin/dwl-session
            Type=Application
            DesktopNames=dwl
          '';
          passthru.providedSessions = [ "dwl" ];
        };
      in
      {
        services.displayManager.sessionPackages = [ dwl-session-file ];

        # Stock bindings: Super+p runs the launcher (menucmd), Super+Shift+Return foot.
        environment.systemPackages = [
          dwl
          pkgs.bemenu
          pkgs.foot
        ];
      };
  };
}
