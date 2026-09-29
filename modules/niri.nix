{ ... }:
{
  den.aspects.niri = {
    nixos = { ... }: {
      programs.niri.enable = true;
    };
    homeManager = { ... }: {
      wayland.windowManager.niri = {
        enable = true;

        # Pull in niri's shipped default-config.kdl verbatim rather than
        # hand-rolling a config. Everything below is layered on top of it.
        enableDefaultConfig = true;

        settings = {
          prefer-no-csd = {};
          binds = {
            "Mod+T" =  {
              _props.hotkey-overlay-title = "Open a Terminal";
              spawn = ["alacritty"];
            };
          };

          # Matches mango's dual layout (mango.nix) so the eww bar's keyboard
          # widget (modules/eww/eww.yuck) has something real to switch.
          input.keyboard.xkb.layout = "us,gr";

          # Repeated top-level nodes (two spawn-at-startup commands) need the
          # `_children` list form rather than a single spawn-at-startup key.
          _children = [
            {
              # niri has no built-in wallpaper support, so spawn swaybg
              # (already installed via the wayland aspect). Scoped to niri's
              # own startup rather than a graphical-session.target user unit
              # so it doesn't also fire under sway, which paints its own
              # background via `output * bg`.
              spawn-at-startup._args = [
                "swaybg"
                "-i"
                "${../assets/1r1kk9qi00961.png}"
                "-m"
                "fill"
              ];
            }
            {
              # eww's own bar (modules/eww.nix) — niri-only, the way waybar
              # is sway-only via sway.nix's startup command.
              spawn-at-startup._args = [ "eww" "open" "bar" ];
            }
          ];
        };
      };
    };
  };
}
