{ inputs, ... }:
{
  den.aspects.sops = {
    nixos = { ... }: {
      imports = [ inputs.sops-nix.nixosModules.sops ];
      sops = {
        defaultSopsFile = ../secrets/secrets.yaml;
        defaultSopsFormat = "yaml";
        age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      };
    };
    homeManager = { config, pkgs, ... }: {
      imports = [ inputs.sops-nix.homeManagerModules.sops ];
      home.packages = with pkgs; [
        sops
        age
        ssh-to-age
      ];
      sops = {
        defaultSopsFile = ../secrets/secrets.yaml;
        defaultSopsFormat = "yaml";
        age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
      };
    };
  };
}
