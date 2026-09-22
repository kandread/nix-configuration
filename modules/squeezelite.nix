{ ... }:
{
  den.aspects.squeezelite = {
    nixos = { host, ... }: {
      services.squeezelite = {
        enable = true;
        extraArgs = {
          "minigland" = "-o front:CARD=DACR26,DEV=0 -s 192.168.0.145";
          "workgland" = "-o front:CARD=II,DEV=0 -s pcp.taild7caec.ts.net";
          "x1gland"   = "-o default -s pcp.taild7caec.ts.net";
        }.${host.name};
      };
    };
  };
}
