{ inputs, ... }:
{
  den.aspects.firefox = {
    nixos = { ... }: {
      programs.firefox.enable = true;
    };
    homeManager = { pkgs, config, ... }: {
      programs.firefox = {
        enable = true;
        configPath = "${config.xdg.configHome}/mozilla/firefox";
        profiles.kandread = {
          isDefault = true;
          extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
            # Security & Privacy
            ublock-origin         # ad/tracker blocking — essential
            clearurls             # strip tracking parameters from URLs
            decentraleyes         # local CDN to prevent tracking via third-party CDNs
            privacy-badger        # learns to block invisible trackers
            multi-account-containers  # isolate sites in separate cookie jars

            # Cookies — keep what you want, reject the rest
            cookie-autodelete     # auto-delete cookies when tab closes, whitelist specific sites
            istilldontcareaboutcookies  # auto-dismiss cookie banners

            # Distraction-free UI
            sponsorblock          # skip sponsored segments in YouTube videos
            darkreader            # dark mode everywhere

            # Utilities
            proton-pass             # password manager
            proton-vpn

            # Productivity
            zotero-connector
          ];

          settings = {
            # --- Distraction-free UI ---
            "browser.tabs.inTitlebar" = 0;
            "browser.toolbars.bookmarks.visibility" = "never";
            "browser.tabs.tabMinWidth" = 0;
            "browser.tabs.tabmanager.enabled" = false;

            # --- Privacy ---
            "privacy.trackingprotection.enabled" = true;
            "privacy.trackingprotection.socialtracking.enabled" = true;
            "privacy.fingerprintingProtection" = true;
            "privacy.resistFingerprinting" = false; # canvasblocker handles this better
            "network.cookie.cookieBehavior" = 1;    # block third-party cookies
            "network.http.referer.XOriginPolicy" = 2;
            "network.http.referer.XOriginTrimmingPolicy" = 2;
            "dom.security.https_only_mode" = true;
            "dom.security.https_only_mode_ever_enabled" = true;
            "signon.rememberSignons" = false; # use our own password manager

            # --- Telemetry off ---
            "toolkit.telemetry.enabled" = false;
            "toolkit.telemetry.unified" = false;
            "toolkit.telemetry.archive.enabled" = false;
            "datareporting.healthreport.uploadEnabled" = false;
            "datareporting.policy.dataSubmissionEnabled" = false;
            "browser.crashReports.unsubmittedCheck.enabled" = false;
            "browser.ping-centre.telemetry" = false;

            # --- UI cleanup ---
            "browser.newtabpage.enabled" = false;
            "browser.startup.homepage" = "about:blank";
            "browser.newtabpage.activity-stream.feeds.telemetry" = false;
            "browser.newtabpage.activity-stream.telemetry" = false;
            "browser.newtabpage.activity-stream.showSponsored" = false;
            "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
            "browser.newtabpage.activity-stream.default.sites" = "";
            "extensions.pocket.enabled" = false;
            "identity.fxaccounts.enabled" = false;

            # --- Vertical tabs ---
            "sidebar.verticalTabs" = true;
            "sidebar.verticalTabs.dragToPinPromo.dismissed" = true;
            "sidebar.expandOnHover" = true;
            "sidebar.main.tools" = "history,bookmarks";

          };

          search = {
            force = true;
            default = "ddg";
            engines = {
              "Nix Packages" = {
                urls = [{
                  template = "https://search.nixos.org/packages";
                  params = [
                    { name = "type"; value = "packages"; }
                    { name = "query"; value = "{searchTerms}"; }
                  ];
                }];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@np" ];
              };
              "NixOS Options" = {
                urls = [{
                  template = "https://search.nixos.org/options";
                  params = [
                    { name = "query"; value = "{searchTerms}"; }
                  ];
                }];
                definedAliases = [ "@no" ];
              };
              "google".metaData.hidden = true;
              "amazondotcom-us".metaData.hidden = true;
              "bing".metaData.hidden = true;
              "ebay".metaData.hidden = true;
            };
          };
        };
      };
    };
  };
}
