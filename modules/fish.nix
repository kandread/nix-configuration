{ ... }:
{
  den.aspects.fish = {
    nixos = { ... }: {
      programs.fish.enable = true;
    };

    homeManager = { pkgs, ... }: {
      programs.fish = {
        enable = true;
        interactiveShellInit = ''
          set fish_greeting ""
        '';
        shellAliases = {
          ls  = "eza --icons";
          ll  = "eza --icons -l";
          la  = "eza --icons -la";
          lt  = "eza --icons --tree";
          cat = "bat";
          grep = "rg";
          m = "mkdir -p";
         };
        plugins = [
          {
            name = "tide";
            src = pkgs.fishPlugins.tide.src;
          }
          {
            name = "z";
            src = pkgs.fishPlugins.z.src;
          }
          {
            name = "fzf-fish";
            src = pkgs.fishPlugins.fzf-fish.src;
          }
          {
            name = "puffer";
            src = pkgs.fishPlugins.puffer.src;
          }
          {
            name = "autopair";
            src = pkgs.fishPlugins.autopair.src;
          }
          {
            name = "colored-man-pages";
            src = pkgs.fishPlugins.colored-man-pages.src;
          }
        ];
      };
    };
  };
}
