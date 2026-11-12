{ ... }:
{
  # kwm's runtime config (~/.config/kwm/config.zon) and kwim's (input
  # devices). The compositor, kwm and kwim themselves, the session file and
  # the portals come from the river aspect (river.nix).
  den.aspects.kwm = {
    homeManager = { pkgs, lib, ... }:
      let
        # bemenu asks for its -W width and assumes the compositor has answered
        # by the end of a roundtrip. river 0.4 configures layer surfaces
        # asynchronously, so bemenu's first render re-requested the full
        # output width and the menu spanned the whole screen.
        bemenu = pkgs.bemenu.overrideAttrs (old: {
          patches = (old.patches or [ ]) ++ [ ./kwm/bemenu-async-width.patch ];
        });

        # bemenu-run keeps no history, so the launcher is this wrapper
        # (carried over from dwl.nix): recently run commands first, then every
        # other executable on PATH. History holds the last 50 distinct entries.
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
            } | awk 'NF && !seen[$0]++' | ${bemenu}/bin/bemenu "$@"
          ) || exit
          [ -n "$sel" ] || exit

          { printf '%s\n' "$sel"; grep -vxF -- "$sel" "$hist"; } | head -n 50 > "$hist.tmp"
          mv "$hist.tmp" "$hist"

          exec ${pkgs.runtimeShell} -c "$sel"
        '';

        # Same look as dwl: centered, vertical list, gigavolt palette.
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
        launcher = pkgs.writeShellScript "kwm-launcher" ''
          exec ${bemenu-recent} ${lib.escapeShellArgs menuStyle} -p Run
        '';

        lock = pkgs.writeShellScript "kwm-lock" ''
          exec ${pkgs.swaylock-effects}/bin/swaylock --clock --indicator \
            --indicator-radius 100 --indicator-thickness 7 \
            --indicator-idle-visible --effect-blur 7x5 \
            --effect-vignette 0.5:0.5 --screenshots
        '';
        # Region screenshot to ~/Pictures/Screenshots, or to the clipboard.
        shot-file = pkgs.writeShellScript "kwm-shot-file" ''
          mkdir -p ~/Pictures/Screenshots
          ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" \
            ~/Pictures/Screenshots/"$(date +%Y-%m-%d_%H-%M-%S)".png
        '';
        shot-clip = pkgs.writeShellScript "kwm-shot-clip" ''
          ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.wl-clipboard}/bin/wl-copy
        '';

        # Feeds kwm's bar status (the fifo is created by tmpfiles below, since
        # kwm only opens it and never creates it): volume, network, RAM,
        # battery (only where there is one) and the clock. Icons are drawn in
        # the accent colour with kwm's ^#RRGGBBAA / ^#! markup. kwm keeps at
        # most 256 bytes of a status line, markup included, so the SSID is
        # cut short.
        #
        # Redraws every 5 s, and at once when PipeWire reports a sink change
        # (volume keys) or NetworkManager reports a state change.
        status = pkgs.writeShellScript "kwm-status" ''
          fifo="$XDG_RUNTIME_DIR/kwm-status"
          [ -p "$fifo" ] || exit 1
          exec 3<>"$fifo"

          ic() { printf '^#40bfffff%s^#! ' "$1"; }
          sep='  '

          volume() {
            local v
            v=$(${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null) || return
            case $v in
              *MUTED*) printf '%smuted' "$(ic $'\Uf0581')" ;;
              *) printf '%s%s%%' "$(ic $'\Uf057e')" "$(awk '{ printf "%d", $2 * 100 + 0.5 }' <<<"$v")" ;;
            esac
          }

          network() {
            local type state conn wifi="" wired=""
            while IFS=: read -r type state conn; do
              [ "$state" = connected ] || continue
              case $type in
                ethernet) wired=1 ;;
                wifi) [ -n "$wifi" ] || wifi=''${conn//\\:/:} ;;
              esac
            done < <(${pkgs.networkmanager}/bin/nmcli -t -f TYPE,STATE,CONNECTION dev 2>/dev/null)
            if [ -n "$wired" ]; then
              printf '%swired' "$(ic $'\Uf0200')"
            elif [ -n "$wifi" ]; then
              [ "''${#wifi}" -gt 16 ] && wifi="''${wifi:0:15}…"
              printf '%s%s' "$(ic $'\Uf05a9')" "$wifi"
            else
              printf '%soffline' "$(ic $'\Uf05aa')"
            fi
          }

          memory() {
            printf '%s%s' "$(ic $'\Uf035b')" \
              "$(awk '/^MemTotal:/ { t = $2 } /^MemAvailable:/ { a = $2 }
                      END { printf "%.1fG", (t - a) / 1048576 }' /proc/meminfo)"
          }

          battery() {
            local b cap st icon
            for b in /sys/class/power_supply/BAT*; do
              [ -r "$b/capacity" ] || continue
              cap=$(<"$b/capacity") st=$(<"$b/status")
              if [ "$st" = Charging ]; then icon=$'\Uf0084'
              elif [ "$cap" -ge 90 ]; then icon=$'\Uf0079'
              elif [ "$cap" -ge 70 ]; then icon=$'\Uf0081'
              elif [ "$cap" -ge 50 ]; then icon=$'\Uf007f'
              elif [ "$cap" -ge 30 ]; then icon=$'\Uf007d'
              elif [ "$cap" -ge 15 ]; then icon=$'\Uf007b'
              else icon=$'\Uf008e'
              fi
              if [ "$st" != Charging ] && [ "$cap" -lt 15 ]; then
                printf '%s^#ff5f5fff%s%%^#!%s' "$(ic "$icon")" "$cap" "$sep"
              else
                printf '%s%s%%%s' "$(ic "$icon")" "$cap" "$sep"
              fi
              return
            done
          }

          draw() {
            printf '%s%s%s%s%s%s%s%s\n' \
              "$(volume)" "$sep" "$(network)" "$sep" "$(memory)" "$sep" \
              "$(battery)" "$(date '+%a %d %b  %H:%M')" >&3
          }

          # One line per event from either monitor wakes the loop early.
          exec 4< <(
            ${pkgs.pulseaudio}/bin/pactl subscribe 2>/dev/null |
              grep --line-buffered -E "'change' on (sink|server)" &
            ${pkgs.networkmanager}/bin/nmcli monitor 2>/dev/null &
            wait
          )
          feeder=$!
          trap 'kill "$feeder" 2>/dev/null' EXIT

          while :; do
            draw
            read -r -t 5 -u 4 _
            case $? in
              # Coalesce bursts (a held volume key sends many events).
              0) while read -r -t 0.1 -u 4 _; do :; done ;;
              # Both monitors gone (EOF): fall back to plain polling.
              1) sleep 5 ;;
            esac
          done
        '';

        wallpaper = ../assets/1r1kk9qi00961.png;

        spawnKey = { keysym, mod4 ? true, shift ? false, mod1 ? false, script }: ''
          .{
              .keysym = "${keysym}",
              .modifiers = .{ .mod4 = ${lib.boolToString mod4}, .shift = ${lib.boolToString shift}, .mod1 = ${lib.boolToString mod1} },
              .event = .{ .click = .{ .pressed = .{ .spawn = .{ .argv = .{ "${script}" } } } } },
          },
        '';

        # kwm replaces list-valued settings wholesale rather than merging
        # them, so the full default key list lives in kwm/default-keys.zon
        # (verbatim from kwm's config.def.zon, rev ee81d6e) with the launcher
        # swapped for the bemenu one. Extra keys are appended after it.
        # Bindings added on top of the defaults:
        #   Super+q                lock the screen
        #   Print / Shift+Print    region screenshot to file / clipboard
        #   Super+Shift+s          region screenshot to clipboard
        defaultKeys =
          builtins.replaceStrings
            [ ''.spawn_shell = .{ .cmd = "wmenu-run" }'' ]
            [ ''.spawn = .{ .argv = .{ "${launcher}" } }'' ]
            (builtins.readFile ./kwm/default-keys.zon);
        extraKeys = lib.concatStrings [
          (spawnKey { keysym = "q"; script = lock; })
          (spawnKey { keysym = "Print"; mod4 = false; script = shot-file; })
          (spawnKey { keysym = "Print"; mod4 = false; shift = true; script = shot-clip; })
          (spawnKey { keysym = "s"; shift = true; script = shot-clip; })
        ];

        kwmConfig = ''
          .{
              .startup_cmds = .{
                  .{ "${pkgs.swaybg}/bin/swaybg", "-i", "${wallpaper}", "-m", "fill" },
                  // Scale 1.5 and output layout come from the kanshi profiles
                  // (wayland.nix).
                  .{ "${pkgs.kanshi}/bin/kanshi" },
                  .{ "${status}" },
              },

              .xcursor_theme = .{ .name = "Bibata-Modern-Classic", .size = 24 },

              // swaybg paints the wallpaper; a solid background would cover it.
              .background = null,

              .bar = .{
                  .tags = .{
                      .tags = .{ "1", "2", "3", "4", "5", "6", "7", "8", "9" },
                      // Patched option: hide tags that are empty and unfocused.
                      .hide_vacant = true,
                      .click = .{
                          .left = .{ .set_output_tag = .{ .tag = .{ .tag = 0 } } },
                          .right = .{ .toggle_output_tag = .{ .mask = 0 } },
                          .middle = .{ .toggle_window_tag = .{ .mask = 0 } },
                      },
                  },
                  .font = "MesloLGS Nerd Font:size=11",
                  .scheme = .{
                      .normal = .{ .fg = 0xe9e7e1ff, .bg = 0x202126ff },
                      .select = .{ .fg = 0x202126ff, .bg = 0x40bfffff },
                  },
                  .mode = .{
                      .tags = .{
                          .{ "default", "" },
                          .{ "passthrough", "P" },
                          .{ "floating", "F" },
                      },
                      .click = .{
                          .left = .{ .switch_mode = .{ .mode = "default" } },
                      },
                  },
                  .status = .{
                      .data = .{ .fifo = "''${XDG_RUNTIME_DIR}/kwm-status" },
                      // kwm only takes clicks on the status area as a whole.
                      .click = .{
                          .left = .{ .spawn = .{ .argv = .{ "${pkgs.pavucontrol}/bin/pavucontrol" } } },
                          .middle = .{ .spawn = .{ .argv = .{ "foot" } } },
                      },
                  },
                  .override_colors = .{
                      .{
                          .area = .{ .mode = null },
                          .scheme = .{
                              .normal = .{ .fg = 0x202126ff, .bg = 0x40bfffff },
                          },
                      },
                  },
              },

              .border = .{
                  .width = 2,
                  .color = .{
                      .focus = 0x40bfffff,
                      .unfocus = 0x5a576eff,
                      .swallowing = 0x0830e6ff,
                  },
              },

              // dwl's gappx of 8, on every layout.
              .layout = .{
                  .tile = .{ .inner_gap = 8, .outer_gap = 8 },
                  .grid = .{ .inner_gap = 8, .outer_gap = 8 },
                  .monocle = .{ .gap = 8 },
                  .deck = .{ .inner_gap = 8, .outer_gap = 8 },
                  .scroller = .{ .inner_gap = 8, .outer_gap = 8 },
                  .centered_master = .{ .inner_gap = 8, .outer_gap = 8 },
              },

              .bindings = .{
                  .key = .{
          ${defaultKeys}
          ${extraKeys}
                  },
              },

              // Replaces the defaults (which tag chromium). foot is a terminal
              // so it can be swallowed; mpv and zoom's meeting windows float,
              // as in dwl.
              .window_rules = .{
                  .{ .app_id = .{ .str = "", .match_null = true }, .floating = true },
                  .{ .app_id = .{ .str = "zenity" }, .floating = true },
                  .{ .app_id = .{ .str = "xdg-desktop-portal-gtk" }, .floating = true },
                  .{ .app_id = .{ .str = "mpv" }, .floating = true },
                  .{ .app_id = .{ .str = "zoom" }, .title = .{ .str = "Meeting" }, .floating = true },
                  .{ .app_id = .{ .str = "foot" }, .is_terminal = true, .scroller_mfact = 0.8 },
              },
          }
        '';

        # kwm is built with -Dkwim=false and the river module starts kwim by
        # hand with no -c, so input settings are read from kwim's own file.
        kwimConfig = ''
          .{
              .input_device_rules = .{
                  .{ .repeat_info = .{ .rate = 50, .delay = 300 } },
              },
              // dwl had natural scrolling on every device, plus tap-to-click.
              .libinput_device_rules = .{
                  .{ .name = .{ .str = ".*[tT]ouchpad", .regex = true }, .tap = .enabled, .drag = .enabled, .natural_scroll = .enabled },
                  .{ .natural_scroll = .enabled },
              },
              // Both Shifts together toggle between US and Greek, as in dwl.
              .xkb_keyboard_rules = .{
                  .{
                      .keymap = .{
                          .options = .{
                              .rules = null,
                              .model = null,
                              .layout = "us,gr",
                              .variant = null,
                              .options = "grp:shifts_toggle",
                          },
                      },
                  },
              },
          }
        '';
      in
      {
        xdg.configFile."kwm/config.zon".text = kwmConfig;
        xdg.configFile."kwim/config.zon".text = kwimConfig;

        # kwm opens the status fifo but never creates it.
        systemd.user.tmpfiles.rules = [ "p %t/kwm-status 0600 - - -" ];

        home.packages = [ pkgs.bemenu ];
      };
  };
}
