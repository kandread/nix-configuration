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
            # Deck layout ([D], Super+Shift+d): own small patch, built on gaps.
            ./dwl/deck.patch
            # menu (dwl-patches, 0.8 version, applies to 0.9 with offsets):
            # Super+o picks a window to focus, Super+Shift+o a layout. The
            # menu commands are pointed at bemenu in postPatch.
            ./dwl/menu.patch
          ];
          postPatch = (old.postPatch or "") + ''
            sed -i \
              -e 's/^#define MODKEY .*/#define MODKEY WLR_MODIFIER_LOGO/' \
              -e 's/natural_scrolling = 0;/natural_scrolling = 1;/' \
              -e 's/{ NULL,       0.55f, 1,      1, /{ NULL,       0.55f, 1,      1.5f,/' \
              -e 's/XKB_KEY_s, \( *\)swapfocus,/XKB_KEY_BackSpace, swapfocus,/' \
              -e 's|"wmenu-run", NULL|${menuArgs}, NULL|' \
              -e '/menucmd\[\] = /r ${extraCmds}' \
              -e '/XKB_KEY_p, /r ${extraKeys}' \
              config.def.h
            substituteInPlace config.def.h \
              --replace-fail '"wmenu -i -l 10 -p Windows"' ${lib.escapeShellArg ''"${bemenuCmd} -p Windows"''} \
              --replace-fail '"wmenu -i -p Layouts"' ${lib.escapeShellArg ''"${bemenuCmd} -p Layouts"''}
          '';
        });

        # Extra spawn bindings, spliced into config.def.h by the sed above:
        # Super+Alt+l locks the screen, Super+Shift+4 screenshots a region to
        # ~/Pictures/Screenshots, Super+Ctrl+Shift+4 to the clipboard (same
        # as the niri config). Shift+4 is XKB_KEY_dollar to dwl.
        extraCmds = pkgs.writeText "dwl-extra-cmds.h" ''
          static const char *lockcmd[] = { "${pkgs.runtimeShell}", "-c", "${pkgs.swaylock-effects}/bin/swaylock --clock --indicator --indicator-radius 100 --indicator-thickness 7 --indicator-idle-visible --effect-blur 7x5 --effect-vignette 0.5:0.5 --screenshots", NULL };
          static const char *shotfilecmd[] = { "${pkgs.runtimeShell}", "-c", "mkdir -p ~/Pictures/Screenshots && ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png", NULL };
          static const char *shotclipcmd[] = { "${pkgs.runtimeShell}", "-c", "${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.wl-clipboard}/bin/wl-copy", NULL };
        '';
        extraKeys = pkgs.writeText "dwl-extra-keys.h" ''
          { MODKEY,                    XKB_KEY_q,      spawn, {.v = lockcmd} },
          { MODKEY,                  XKB_KEY_s, spawn, {.v = shotfilecmd} },
          { MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_s, spawn, {.v = shotclipcmd} },
        '';

        # bemenu-run keeps no history, so the launcher is this wrapper instead:
        # recently run commands first (most recent on top), then every other
        # executable on PATH. Its arguments go straight to bemenu. History
        # holds the last 50 distinct entries, arguments included.
        bemenu-recent = pkgs.writeShellScript "bemenu-recent" ''
          hist="''${XDG_CACHE_HOME:-$HOME/.cache}/bemenu-recent"
          mkdir -p "$(dirname "$hist")"
          touch "$hist"

          sel=$(
            {
              cat "$hist"
              IFS=:
              # shellcheck disable=SC2086
              find -L $PATH -maxdepth 1 -type f -executable -printf '%f\n' 2>/dev/null | sort -u
            } | awk 'NF && !seen[$0]++' | ${pkgs.bemenu}/bin/bemenu "$@"
          ) || exit
          [ -n "$sel" ] || exit

          { printf '%s\n' "$sel"; grep -vxF -- "$sel" "$hist"; } | head -n 50 > "$hist.tmp"
          mv "$hist.tmp" "$hist"

          exec ${pkgs.runtimeShell} -c "$sel"
        '';

        # Launcher look: centered, vertical list, colors from the stylix
        # gigavolt palette (theming.nix). stylix lives in home-manager, so the
        # hex values are copied from the scheme file rather than read from
        # config.lib.stylix.
        menuStyle = [
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
        menuArgs = lib.concatMapStringsSep ", " (a: "\"${a}\"") ([ "${bemenu-recent}" ] ++ menuStyle);
        # Same look as a single sh command line, for the menu patch (which
        # pipes its own entries into it, so it must be plain bemenu).
        bemenuCmd = "${pkgs.bemenu}/bin/bemenu ${lib.escapeShellArgs menuStyle}";

        # xdg-desktop-portal-wlr chooser (see the xdpw config below): lists the
        # outputs and the open windows in bemenu and prints the choice in the
        # "Monitor: <output>" / "Window: <toplevel identifier>" form xdpw
        # expects. Printing nothing declines the share.
        screencast-chooser = pkgs.writeShellScript "dwl-screencast-chooser" ''
          entries=$(
            {
              ${pkgs.wlr-randr}/bin/wlr-randr --json |
                ${pkgs.jq}/bin/jq -r '.[] | "Monitor: \(.name)\tMonitor: \(.name)"'
              ${pkgs.lswt}/bin/lswt --json |
                ${pkgs.jq}/bin/jq -r '.toplevels[] | "Window: \(.title) | \(."app-id")\tWindow: \(.identifier)"'
            } 2>/dev/null
          )
          sel=$(printf '%s\n' "$entries" | cut -f1 | ${bemenuCmd} -p Share) || exit 0
          [ -n "$sel" ] || exit 0
          printf '%s\n' "$entries" | awk -F'\t' -v s="$sel" '$1 == s { print $2; exit }'
        '';

        # dwl's `-s` command runs once the compositor socket exists, so this
        # takes the place of the autostart patch: background things first,
        # then exec the bar. The bar is waybar with the dwl config written by
        # the waybar aspect (waybar.nix); its dwl/tags and dwl/window modules
        # talk to dwl over the ipc patch.
        dwl-startup = pkgs.writeShellScript "dwl-startup" ''
          # Portals are D-Bus activated, so they need to see the session's
          # environment (xdpw needs WAYLAND_DISPLAY and XDG_CURRENT_DESKTOP).
          export XDG_CURRENT_DESKTOP=dwl
          ${pkgs.systemd}/bin/systemctl --user import-environment \
            WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_RUNTIME_DIR DISPLAY
          ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd \
            WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_RUNTIME_DIR DISPLAY
          # Brings up graphical-session.target, which xdg-desktop-portal (and
          # every graphical-session user unit) requires before it will start.
          ${pkgs.systemd}/bin/systemctl --user start dwl-session.target

          ${pkgs.swaybg}/bin/swaybg -i ${../assets/1r1kk9qi00961.png} -m fill &
          exec ${pkgs.waybar}/bin/waybar -c "$HOME/.config/waybar/dwl.json"
        '';

        # Not exec'd, so the session target (and graphical-session.target with
        # it) goes down when dwl exits instead of lingering into the next login.
        dwl-session = pkgs.writeShellScriptBin "dwl-session" ''
          ${dwl}/bin/dwl -s ${dwl-startup}
          ${pkgs.systemd}/bin/systemctl --user stop dwl-session.target
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

        # graphical-session.target refuses manual starts; a compositor brings
        # it up by starting a target bound to it (same shape as sway's).
        systemd.user.targets.dwl-session = {
          description = "dwl compositor session";
          bindsTo = [ "graphical-session.target" ];
          wants = [ "graphical-session-pre.target" ];
          after = [ "graphical-session-pre.target" ];
        };

        # Screen sharing: route ScreenCast/Screenshot to xdpw for the dwl
        # desktop (no upstream dwl-portals.conf exists), and replace its
        # monitor-only slurp chooser with one that also offers windows.
        xdg.portal.config.dwl = {
          default = [ "gtk" ];
          "org.freedesktop.impl.portal.Inhibit" = [ "none" ];
          "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
          "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
        };
        environment.etc."xdg/xdg-desktop-portal-wlr/dwl".text = ''
          [screencast]
          chooser_type=simple
          chooser_cmd=${screencast-chooser}
        '';

        # Stock bindings: Super+p runs the launcher (menucmd), Super+Shift+Return foot.
        environment.systemPackages = [
          dwl
          pkgs.bemenu
          pkgs.foot
        ];
      };
  };
}
