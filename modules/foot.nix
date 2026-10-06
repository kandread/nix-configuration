{ ... }:
{
  den.aspects.foot = {
    homeManager = { pkgs, ... }: {
      programs.foot = {
        enable = true;

        settings = {
          main = {
            shell = "${pkgs.fish}/bin/fish";
            font = "MesloLGS Nerd Font:size=12";
            pad = "8x8";
            term = "xterm-256color";
          };

          scrollback.lines = 10000;

          cursor = {
            style = "beam";
            blink = "yes";
          };

          mouse.hide-when-typing = "yes";

          # Nord — matches the kitty and alacritty themes for visual
          # consistency across terminals.
          colors = {
            background = "2e3440";
            foreground = "d8dee9";
            regular0 = "3b4252";
            regular1 = "bf616a";
            regular2 = "a3be8c";
            regular3 = "ebcb8b";
            regular4 = "81a1c1";
            regular5 = "b48ead";
            regular6 = "88c0d0";
            regular7 = "e5e9f0";
            bright0 = "4c566a";
            bright1 = "bf616a";
            bright2 = "a3be8c";
            bright3 = "ebcb8b";
            bright4 = "81a1c1";
            bright5 = "b48ead";
            bright6 = "8fbcbb";
            bright7 = "eceff4";
          };
        };
      };
    };
  };
}
