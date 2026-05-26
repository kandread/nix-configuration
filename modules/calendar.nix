{ ... }:
{
  den.aspects.calendar = {
    homeManager = { pkgs, ... }: {

      accounts.calendar = {
        basePath = ".calendars";
        accounts.umass = {
          local = {
            path = "~/.calendars/umass";
            type = "filesystem";
            fileExt = ".ics";
          };
          remote = {
            type = "caldav";
            url = "http://localhost:1080/users/kandread@umass.edu/calendar/";
            userName = "kandread@umass.edu";
            passwordCommand = ["cat" "~/.cache/umass"];
          };
          vdirsyncer = {
            enable = true;
            collections = [ "calendar" ];
            metadata = [ "displayname" "color" ];
            timeRange = {
              end = "datetime.now() + timedelta(days=30)";
              start = "datetime.now() - timedelta(days=30)";
            };
          };
          khal = {
            enable = true;
            type = "discover";
            addresses = [ "kandread@umass.edu" ];
          };
        };
      };

      programs.vdirsyncer = {
        enable = true;
        statusPath = "~/.calendars/status";
      };

      programs.khal = {
        enable = true;
        settings = {
          default = {
            default_calendar = "calendar";
          };
          view = {
            agenda_event_format =
              "{calendar-color}{cancelled}{start-end-time-style} {title}{repeat-symbol}{reset}";
          };
        };
        locale = {
          datetimeformat = "%Y-%m-%d %H:%M";
          longdateformat = "%Y-%m-%d %a";
          longdatetimeformat = "%Y-%m-%d %H:%M";
          timeformat = "%H:%M";
          dateformat = "%Y-%m-%d";
        };
      };

    };
  };
}
