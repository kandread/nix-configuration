{ ... }:
{
  den.aspects.dwl = {
    nixos = { pkgs, ... }:
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
            ./dwl/client-opacity-focus.patch
            ./dwl/gaps.patch
          ];
          postPatch = (old.postPatch or "") + ''
            sed -i \
              -e 's/^#define MODKEY .*/#define MODKEY WLR_MODIFIER_LOGO/' \
              -e 's/natural_scrolling = 0;/natural_scrolling = 1;/' \
              -e 's/{ NULL,       0.55f, 1,      1, /{ NULL,       0.55f, 1,      1.5f,/' \
              config.def.h
          '';
        });

        # dwl's `-s` command runs once the compositor socket exists, so this
        # takes the place of the autostart patch: background things first,
        # then exec somebar so it inherits dwl's state pipe as its stdin. The
        # clock loop retries until somebar's socket exists, then updates the
        # status text once a minute, on the minute.
        dwl-startup = pkgs.writeShellScript "dwl-startup" ''
          ${pkgs.swaybg}/bin/swaybg -i ${../assets/1r1kk9qi00961.png} -m fill &
          (
            while true; do
              ${pkgs.somebar}/bin/somebar -c status "$(${pkgs.coreutils}/bin/date '+%a %d %b  %H:%M')"
              ${pkgs.coreutils}/bin/sleep $((60 - 10#$(${pkgs.coreutils}/bin/date +%S)))
            done
          ) &
          exec ${pkgs.somebar}/bin/somebar
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

        # Stock bindings: Super+p runs `wmenu-run`, Super+Shift+Return foot.
        environment.systemPackages = [
          dwl
          pkgs.wmenu
          pkgs.foot
        ];
      };
  };
}
