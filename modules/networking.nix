{ ... }:
{
  den.aspects.networking = {
    nixos = { ... }: {
      networking.networkmanager = {
        enable = true;
        ensureProfiles.profiles = {
          eduroam = {
            connection = {
              id = "eduroam";
              type = "wifi";
              interface-name = "wlp0s20f3";
            };
             wifi = {
               mode = "infrastructure";
               ssid = "eduroam";
             };
              wifi-security = {
                key-mgmt = "wpa-eap";
              };
              "802-1x" = {
                eap = "ttls";
                identity = "kandread@umass.edu";
                # client-cert = "/etc/ssl/certs/eduroam/cert.pem";
                phase2-auth = "pap"; # mschapv2
                ca-cert = "/etc/ssl/certs/ca-bundle.crt";
              };
               ipv4 = {
                 method = "auto";
               };
               ipv6 = {
                 method = "auto";
               };
          };
        };
      };
    };

    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        gp-saml-gui
      ];
    };
  };
}
