{ ... }:
{
  den.aspects.writing = {
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        pandoc
        texlive.combined.scheme-full
        typst
        tinymist
        math-preview
        hunspell
        hunspellDicts.en_US-large
        libreoffice-fresh
      ];
    };
  };
}
