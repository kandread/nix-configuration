{ ... }:
{
  den.aspects.chromium = {
    homeManager = { pkgs, ... }: {
      programs.chromium = {
        enable = true;
        package = pkgs.chromium;
        commandLineArgs = [
          "--ozone-platform-hint=auto"
        ];
        extensions = [
          { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
          { id = "ghmbeldphafepmbegfdlkpapadhbakde"; } # proton pass
        ];
      };
    };
  };
}
