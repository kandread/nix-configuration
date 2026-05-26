{ ... }:
{
  den.aspects.davmail = {
    homeManager = { ... }: {
      services.davmail = {
        enable = true;
        settings = {
          "davmail.mode" = "O365Interactive";
          "davmail.logFilePath" = "/home/kandread/.cache/davmail.log";
          "davmail.enableKeepAlive" = "true";
        };
      };
    };
  };
}
