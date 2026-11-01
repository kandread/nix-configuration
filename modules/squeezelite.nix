{ ... }:
{
  den.aspects.squeezelite = {
    nixos = { host, lib, pkgs, ... }:
    let
      pipewireHosts = [ "workgland" "x1gland" ];
      viaPipewire = builtins.elem host.name pipewireHosts;
    in lib.mkMerge [
      (lib.mkIf (!viaPipewire) {
        services.squeezelite = {
          enable = true;
          extraArgs = {
            "minigland" = "-o front:CARD=DACR26,DEV=0 -s 192.168.0.145";
          }.${host.name};
        };
      })

      # Output through PipeWire (user service) so audio mixes with other apps
      # instead of locking the DAC.
      (lib.mkIf viaPipewire {
        systemd.user.services.squeezelite = {
          description = "Software Squeezebox emulator";
          wantedBy = [ "default.target" ];
          after = [ "pipewire.service" "network-online.target" ];
          wants = [ "network-online.target" ];
          # workgland pins the Topping DAC; x1gland uses the default sink.
          environment = lib.optionalAttrs (host.name == "workgland") {
            PIPEWIRE_NODE = "alsa_output.usb-Topping_DX5_II-00.HiFi__Headphones__sink";
          };
          serviceConfig = {
            ExecStart = "${pkgs.squeezelite}/bin/squeezelite -n ${host.name} -o pipewire -s pcp.taild7caec.ts.net";
            Restart = "on-failure";
            RestartSec = 5;
          };
        };
      })
    ];
  };
}
