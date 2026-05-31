{ ... }:
{
  den.aspects.email = {
    homeManager = { pkgs, config, ... }: {
      sops.secrets.umass = { };
      programs = {
        mbsync.enable = true;
        mu.enable = true;
        msmtp.enable = true;
        afew = {
          enable = true;
          extraConfig = ''
            [SpamFilter]
            [KillThreadsFilter]
            [ListMailsFilter]
            [ArchiveSentMailsFilter]
            sent_tag = sent
            [FolderNameFilter]
            maildir_separator = /
            folder_transforms = Trash:deleted Junk:spam Drafts:draft Archive:archived Sent:sent Inbox:inbox
            [Filter.jhm]
            query = 'to:andreadis.jhm@ametsoc.org'
            tags = +jhm
            message = JHM messages
            [MailMover]
            folders = umass/Inbox umass/Sent
            rename = True
            umass/Inbox = 'tag:spam':umass/Junk 'tag:deleted':umass/Trash 'tag:sent':umass/Sent 'tag:draft':umass/Drafts 'tag:archived':umass/Archive
            umass/Sent = 'tag:deleted':umass/Trash
            [InboxFilter]
          '';
        };
        notmuch = {
          enable = true;
          new = {
            tags = [ "new" ];
            ignore = [ "Archive1" "Conversation History" "Unsent Messages" ];
          };
          search.excludeTags = [ "deleted" "spam" "archived" ];
          extraConfig = {
            index = {
              "header.List" = "List-ID";
            };
          };
          hooks = {
            postNew = ''
              afew -n -t
              afew -n -m
            '';
          };
        };
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
