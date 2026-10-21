{ ... }:
{
  den.aspects.gimp = {
    homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.gimp ];
    };
  };
}
