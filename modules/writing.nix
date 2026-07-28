{ ... }:
{
  den.aspects.writing = {
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        pandoc
        texliveFull
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
