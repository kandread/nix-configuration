{ inputs, ... }:
{
  den.aspects.flox = {
    nixos = { pkgs, ... }: {
      # Binary cache so flox doesn't build from source
      nix.settings = {
        extra-trusted-substituters = [ "https://cache.flox.dev" ];
        extra-trusted-public-keys = [
          "flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs="
        ];
      };
      environment.systemPackages = [
        inputs.flox.packages.${pkgs.system}.default
      ];
    };
  };
}
