{ ... }:
{
  den.aspects.gpg = {
    homeManager = { pkgs, ... }: {
      services.gpg-agent = {
        enable = true;
        pinentry.package = pkgs.pinentry-gnome3;
        enableSshSupport = true;
        defaultCacheTtl = 86400;
        maxCacheTtl = 86400;
      };
    };
  };
}
