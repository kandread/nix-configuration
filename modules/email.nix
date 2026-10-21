{ ... }:
{
  den.aspects.email = {
    homeManager = { pkgs, config, ... }: {
      sops.secrets.umass = { };
      programs = {
        mbsync.enable = true;
        mu.enable = true;
        msmtp.enable = true;
        notmuch = {
          enable = true;
          settings = {
            new = {
              tags = [ ];
              ignore = [ "Archive1" "Conversation History" "Unsent Messages" ];
            };
            search.exclude_tags = [ "deleted" "spam" "archived" ];
            index = {
              "header.List" = "List-ID";
            };
          };
          hooks = {
            # Move files to the IMAP folder matching their tags before indexing
            preNew = "${pkgs.notmuch-mailmover}/bin/notmuch-mailmover";
            # Keep tags in sync with the folder each message lives in
            postNew = ''
              notmuch tag --batch <<'EOF'
              +inbox -- folder:umass/Inbox and not tag:inbox
              -inbox -- tag:inbox and not folder:umass/Inbox
              +sent -- folder:umass/Sent and not tag:sent
              -sent -- tag:sent and not folder:umass/Sent
              +draft -- folder:umass/Drafts and not tag:draft
              -draft -- tag:draft and not folder:umass/Drafts
              +archived -- folder:umass/Archive and not tag:archived
              -archived -- tag:archived and not folder:umass/Archive
              +spam -- folder:umass/Junk and not tag:spam
              -spam -- tag:spam and not folder:umass/Junk
              +deleted -- folder:umass/Trash and not tag:deleted
              -deleted -- tag:deleted and not folder:umass/Trash
              +jhm -- to:andreadis.jhm@ametsoc.org and not tag:jhm
              EOF
            '';
          };
        };
      };

      xdg.configFile."notmuch-mailmover/config.yaml".text = ''
        maildir: ~/Mail
        rename: true
        rule_match_mode: unique
        rules:
          - folder: umass/Trash
            query: tag:deleted
          - folder: umass/Junk
            query: tag:spam and not tag:deleted
          - folder: umass/Drafts
            query: tag:draft and not tag:deleted and not tag:spam
          - folder: umass/Sent
            query: tag:sent and not tag:deleted and not tag:spam and not tag:draft
          - folder: umass/Archive
            query: tag:archived and not tag:deleted and not tag:spam and not tag:draft and not tag:sent
      '';

      services.mbsync = {
        enable = pkgs.stdenv.hostPlatform.isLinux;
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
          passwordCommand = "${pkgs.coreutils}/bin/cat ${config.sops.secrets.umass.path}";

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

          notmuch.enable = true;

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
