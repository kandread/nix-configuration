{ ... }:
{
  den.aspects.davmail = {
    homeManager = { ... }: {
      services.davmail = {
        enable = true;
        settings = {
          "davmail.mode" = "O365Modern";
          "davmail.logFilePath" = "/home/kandread/.cache/davmail.log";
          "davmail.enableKeepAlive" = "true";
        };
      };
    };
  };
}
