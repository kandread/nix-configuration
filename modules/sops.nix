{ inputs, ... }:
{
  den.aspects.sops = {
    nixos = { ... }: {
      imports = [ inputs.sops-nix.nixosModules.sops ];
      sops = {
        defaultSopsFile = ../secrets/secrets.yaml;
        defaultSopsFormat = "yaml";
        gnupg = {
          home = "/root/.gnupg";
          sshKeyPaths = [ ];
        };
      };
    };
    homeManager = { config, ... }: {
      imports = [ inputs.sops-nix.homeManagerModules.sops ];
      sops = {
        defaultSopsFile = ../secrets/secrets.yaml;
        defaultSopsFormat = "yaml";
        gnupg = {
          home = "${config.home.homeDirectory}/.gnupg";
          sshKeyPaths = [ ];
        };
      };
    };
  };
}
