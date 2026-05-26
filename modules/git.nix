{ inputs, ...}:
{
  den.aspects.git = {
    homeManager = { pkgs, ... }: {
      programs.git = {
        enable = true;
        settings = {
          core = { compression = 0; };
          pull.rebase = false;
          status.showUntrackedFiles = "all";
          credential.helper = "store";
          user = {
            name = "Kostas Andreadis";
            email = "kandread@umass.edu";
          };
          github.user = "kandread";
          alias = {
            s = "status";
            a = "add";
            f = "fetch";
            c = "commit -m";
            k = "checkout";
            b = "branch";
            l = "log";
            p = "pull";
            h = "push";
          };
        };
      };
    };
  };
}
