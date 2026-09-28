{ lib, ... }:
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
      ] ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
        pinentry-gnome3
        brightnessctl
      ];
    };
  };
}
