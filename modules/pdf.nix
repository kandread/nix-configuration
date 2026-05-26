{ ... }:
{
  den.aspects.pdf = {
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        zathura
        ghostscript
        pdftk
      ];
    };
  };
}
