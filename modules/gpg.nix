{ ... }:
{
  den.aspects.gpg = {
    homeManager = { pkgs, ... }: {
      services.gpg-agent = {
        enable = true;
        pinentry.package = if pkgs.stdenv.hostPlatform.isDarwin then pkgs.pinentry_mac else pkgs.pinentry-gnome3;
        enableSshSupport = true;
        defaultCacheTtl = 86400;
        maxCacheTtl = 86400;
      };
    };
  };
}
