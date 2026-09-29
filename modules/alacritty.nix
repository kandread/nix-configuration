{ ... }:
{
  den.aspects.alacritty = {
    homeManager = { pkgs, ... }: {
      programs.alacritty = {
        enable = true;

        settings = {
          env.TERM = "xterm-256color";

          terminal.shell.program = "${pkgs.fish}/bin/fish";

          window = {
            padding = { x = 8; y = 8; };
            decorations = "full";
            opacity = 1.0;
            dynamic_padding = true;
          };

          scrolling.history = 10000;

          font = {
            normal.family = "MesloLGS Nerd Font";
            size = 12;
          };

          cursor = {
            style = { shape = "Beam"; blinking = "On"; };
            blink_interval = 500;
          };

          mouse.hide_when_typing = true;

          # Nord — matches the kitty theme (kitty.nix) for visual consistency
          # across terminals.
          colors = {
            primary = {
              background = "#2e3440";
              foreground = "#d8dee9";
            };
            cursor = {
              text = "#2e3440";
              cursor = "#d8dee9";
            };
            normal = {
              black = "#3b4252";
              red = "#bf616a";
              green = "#a3be8c";
              yellow = "#ebcb8b";
              blue = "#81a1c1";
              magenta = "#b48ead";
              cyan = "#88c0d0";
              white = "#e5e9f0";
            };
            bright = {
              black = "#4c566a";
              red = "#bf616a";
              green = "#a3be8c";
              yellow = "#ebcb8b";
              blue = "#81a1c1";
              magenta = "#b48ead";
              cyan = "#8fbcbb";
              white = "#eceff4";
            };
          };

          keyboard.bindings = [
            { key = "Equals"; mods = "Control"; action = "IncreaseFontSize"; }
            { key = "Minus"; mods = "Control"; action = "DecreaseFontSize"; }
            { key = "Key0"; mods = "Control"; action = "ResetFontSize"; }
            { key = "C"; mods = "Control|Shift"; action = "Copy"; }
            { key = "V"; mods = "Control|Shift"; action = "Paste"; }
          ];
        };
      };
    };
  };
}
