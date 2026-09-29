{ ... }:
{
  den.aspects.eww = {
    homeManager = { ... }: {
      # yuck/scss live in ./eww/ as real files rather than inline Nix strings:
      # eww's `${...}` widget-interpolation syntax collides with Nix string
      # antiquotation, so keeping them separate avoids escaping every one.
      programs.eww = {
        enable = true;
        yuckConfig = builtins.readFile ./eww/eww.yuck;
        scssConfig = builtins.readFile ./eww/eww.scss;
      };
    };
  };
}
