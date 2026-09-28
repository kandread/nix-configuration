{ lib, ... }:
{
  den.aspects.comms = {
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        zoom-us
      ] ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
        zulip
      ];
    };
  };
}
