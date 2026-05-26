{ ... }:
{
  den.aspects.ssh = {
    homeManager = { ... }: {
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        settings = {
          "*" = {
            ForwardAgent = false;
            AddKeysToAgent = "no";
            Compression = false;
            ServerAliveInterval = 0;
            ServerAliveCountMax = 3;
            HashKnownHosts = false;
            UserKnownHostsFile = "~/.ssh/known_hosts";
            ControlMaster = "no";
            ControlPath = "~/.ssh/master-%r@%n:%p";
            ControlPersist = "no";
          };
          "workgland" = {
            HostName = "172.24.104.88";
            User = "kandread";
          };
          "unity" = {
            User = "kandread_umass_edu";
            HostName = "unity.rc.umass.edu";
            IdentityFile = "~/.ssh/unity.key";
          };
          "minigland" = {
            User = "kandread";
            HostName = "192.168.0.221";
          };
        };
      };
    };
  };
}
