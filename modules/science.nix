{ ... }:
{
  den.aspects.science = {
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        zotero
      ];
    };
  };
}
