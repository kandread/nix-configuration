{ ... }:
{
  den.aspects.squeezelite = {
    nixos = { host, lib, pkgs, ... }: lib.mkMerge [
      (lib.mkIf (host.name != "workgland") {
        services.squeezelite = {
          enable = true;
          extraArgs = {
            "minigland" = "-o front:CARD=DACR26,DEV=0 -s 192.168.0.145";
            "x1gland"   = "-s pcp.taild7caec.ts.net";
          }.${host.name};
        };
      })

      # Output through PipeWire (user service) so audio mixes with other apps
      # instead of locking the DAC.
      (lib.mkIf (host.name == "workgland") {
        systemd.user.services.squeezelite = {
          description = "Software Squeezebox emulator";
          wantedBy = [ "default.target" ];
          after = [ "pipewire.service" "network-online.target" ];
          wants = [ "network-online.target" ];
          environment.PIPEWIRE_NODE = "alsa_output.usb-Topping_DX5_II-00.HiFi__Headphones__sink";
          serviceConfig = {
            ExecStart = "${pkgs.squeezelite}/bin/squeezelite -n workgland -o pipewire -s pcp.taild7caec.ts.net";
            Restart = "on-failure";
            RestartSec = 5;
          };
        };
      })
    ];
  };
}
