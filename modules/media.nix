{ ... }:
{
  den.aspects.media = {
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        graphviz
        imagemagick
        ffmpeg
        mpv
        inkscape
      ];
    };
  };
}
