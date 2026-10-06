{ ... }:
{
  den.aspects.qutebrowser = {
    homeManager = { ... }: {
      # Colors come from stylix (targets.qutebrowser).
      programs.qutebrowser = {
        enable = true;

        searchEngines = {
          DEFAULT = "https://duckduckgo.com/?q={}";
          np = "https://search.nixos.org/packages?type=packages&query={}";
          no = "https://search.nixos.org/options?query={}";
        };

        settings = {
          auto_save.session = true;
          content.blocking.enabled = true;
          content.cookies.accept = "no-3rdparty";
          content.autoplay = false;
          content.pdfjs = true;
          content.notifications.enabled = false;
          tabs.show = "multiple";
          tabs.position = "left";
          statusbar.show = "in-mode";
          url.start_pages = [ "about:blank" ];
          url.default_page = "about:blank";
        };
      };
    };
  };
}
