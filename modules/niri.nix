{ ... }:
{
  den.aspects.niri = {
    nixos = { ... }: {
      programs.niri.enable = true;
    };
    homeManager = { lib, ... }:
    {
      # niri's default-config.kdl, spelled out in niri/config.kdl (minus its
      # `spawn-at-startup "waybar"` line, since eww is the bar here, and with
      # comments stripped). Volume steps are 1% instead of 10%.
      # Same position the module uses for its own default-config include.
      wayland.windowManager.niri.extraConfig =
        lib.mkOrder 501 (builtins.readFile ./niri/config.kdl);

      wayland.windowManager.niri = {
        enable = true;

        # The default config is spelled out in niri/config.kdl instead.
        enableDefaultConfig = false;

        settings = {
          prefer-no-csd = {};

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
