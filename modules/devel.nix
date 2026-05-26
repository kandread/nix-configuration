{ ... }:
{
  den.aspects.devel = {
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        uv
        nodejs_latest
        plantuml
        tree-sitter
        devenv
      ];
    };
  };
}
