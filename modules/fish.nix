{ ... }:
{
  den.aspects.fish = {
    nixos = { ... }: {
      programs.fish.enable = true;
    };

    homeManager = { pkgs, ... }: {
      programs.starship = {
        enable = true;
        enableFishIntegration = true;
        settings = {
          add_newline = false;
          format = "$directory$git_branch$git_status$nix_shell$cmd_duration$line_break$character";
          directory.truncation_length = 3;
          git_branch.symbol = " ";
          nix_shell = {
            symbol = " ";
            format = "[$symbol$name]($style) ";
          };
          cmd_duration.min_time = 3000;
          character = {
            success_symbol = "[❯](green)";
            error_symbol = "[❯](red)";
          };
        };
      };

      programs.fish = {
        enable = true;
        interactiveShellInit = ''
          set fish_greeting ""
          direnv hook fish | source

          # Fuzzy-pick a directory from the z history and insert it at the cursor.
          function _fzf_visited_dir
            set -l token (commandline --current-token)
            set -l dir (z -l 2>&1 | sort -rn | string replace -r '^\S+\s+' "" \
              | fzf --height=40% --reverse --query="$token" --prompt="dir> ")
            if test -n "$dir"
              commandline --current-token --replace -- (string escape -- $dir)
            end
            commandline -f repaint
          end
          bind \e\cd _fzf_visited_dir
        '';
        shellAliases = {
          ls  = "eza --icons auto";
          ll  = "eza --icons -l";
          la  = "eza --icons -la";
          lt  = "eza --icons --tree";
          cat = "bat";
          grep = "rg";
          m = "mkdir -p";
         };
        shellAbbrs = {
          nrs = "sudo nixos-rebuild switch --flake ~/.config/dendritic";
          ngc = "sudo nix-collect-garbage -d";
        };
        plugins = [
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
