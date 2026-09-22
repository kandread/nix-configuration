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
              spawn = ["kitty"];
            };
          };
            # niri has no built-in wallpaper support, so spawn swaybg (already
            # installed via the wayland aspect). Scoped to niri's own startup
            # rather than a graphical-session.target user unit so it doesn't
            # also fire under sway, which paints its own background via
            # `output * bg`.
            spawn-at-startup._args = [
              "swaybg"
              "-i"
              "${../assets/1r1kk9qi00961.png}"
              "-m"
              "fill"
            ];
        };
      };
    };
  };
}
