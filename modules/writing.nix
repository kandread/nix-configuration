{ ... }:
{
  den.aspects.writing = {
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        pandoc
        texliveFull
        texlab
        texpresso
        typst
        tinymist
        math-preview
        hunspell
        hunspellDicts.en_US-large
        libreoffice-stable
      ];
    };
  };
}
