{ lib, ... }:
{
  den.aspects.writing = {
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        pandoc
        texliveFull
        texlab
        typst
        tinymist
        math-preview
        hunspell
        hunspellDicts.en_US-large
      ] ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
        libreoffice-stable
      ];
    };
  };
}
