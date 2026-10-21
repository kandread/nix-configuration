{ ... }:
let
  # Fill in once each machine has run syncthing at least once:
  #   syncthing --device-id    (or Actions > Show ID in the web UI on :8384)
  devices = {
    # workgland.id = "XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX";
    # minigland.id = "XXXXXXX-...";
    # x1gland.id   = "XXXXXXX-...";
  };
in
{
  den.aspects.syncthing = {
    nixos = { ... }: {
      # Sync protocol and local discovery
      networking.firewall = {
        allowedTCPPorts = [ 22000 ];
        allowedUDPPorts = [ 22000 21027 ];
      };
    };

    homeManager = { config, ... }: {
      services.syncthing = {
        enable = true;
        settings = {
          devices = devices;
          folders."org" = {
            path = "${config.home.homeDirectory}/Documents/Org";
            devices = builtins.attrNames devices;
            versioning = {
              type = "staggered";
              params = {
                cleanInterval = "3600";
                maxAge = "2592000"; # 30 days
              };
            };
          };
          options.urAccepted = -1; # no usage reporting
        };
      };
    };
  };
}
