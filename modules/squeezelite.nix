{ ... }:
{
  den.aspects.squeezelite = {
    nixos = { host, ... }: {
      services.squeezelite = {
        enable = true;
        extraArgs = {
          "minigland" = "-o front:CARD=DACR26,DEV=0 -s 127.0.0.1";
          "workgland" = "-o front:CARD=Pro,DEV=0 -s minigland.taild7caec.ts.net";
          "x1gland"   = "-o default -s minigland.taild7caec.ts.net";
        }.${host.name};
      };
    };
  };
}
