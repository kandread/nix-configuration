{ ... }:
{
  den.aspects.searx = {
    nixos = { ... }: {
      services.searx = {
        enable = true;
        settings = {
          server.port = 8080;
          server.secret_key = "";
          search.formats = [
            "html"
            "json"
          ];
        };
      };
    };
  };
}
