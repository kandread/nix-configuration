{ ... }:
{
  den.aspects.utilities = {
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        gnupg
        coreutils
        unzip
        zip
        bat
        ripgrep
        fd
        fzf
        jq
        eza
        btop
        rsync
        wget
        vim
        pinentry-gnome3
        brightnessctl
      ];
    };
  };
}
