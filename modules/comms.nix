{ ... }:
{
  den.aspects.comms = {
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        zulip
        zoom
      ];
    };
  };
}
