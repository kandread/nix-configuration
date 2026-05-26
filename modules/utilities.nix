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
        fasd
        rsync
        wget
        vim
        pinentry-gnome3
      ];
    };
  };
}
