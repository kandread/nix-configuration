{ ... }:
{
  den.aspects.email = {
    homeManager = { pkgs, ... }: {
      programs = {
        mbsync.enable = true;
        mu.enable = true;
        msmtp.enable = true;
      };

      services.mbsync = {
        enable = pkgs.stdenv.isLinux;
        frequency = "*:0/5";
      };

      accounts.email = {
        maildirBasePath = "Mail";
        accounts.umass = {
          primary = true;
          address = "kandread@umass.edu";
          aliases = [ "andreadis.jhm@ametsoc.org" ];
          userName = "kandread@umass.edu";
          realName = "Kostas Andreadis";
          passwordCommand = "${pkgs.coreutils}/bin/cat ~/.cache/umass";

          imap = {
            host = "localhost";
            port = 1143;
            tls = {
              enable = false;
              useStartTls = false;
            };
          };

          maildir.path = "umass";

          mu.enable = true;

          mbsync = {
            enable = true;
            create = "maildir";
            expunge = "both";
            remove = "both";
            patterns = [ "*" "!Archive1" "!Conversation History" "!Unsent Messages" "!Trash/Trash" "!Trash/Sent" ];
            extraConfig = {
              account = {
                AuthMech = "LOGIN";
                PipelineDepth = 10;
                Timeout = 120;
              };
              remote = { UseNamespace = "yes"; };
            };
          };

          smtp = {
            host = "localhost";
            port = 1025;
            tls = {
              enable = false;
              useStartTls = false;
            };
          };

          msmtp = {
            enable = true;
            extraConfig = {
              auth = "login";
              logfile = "~/.cache/msmtp.log";
            };
          };
        };
      };
    };
  };
}
