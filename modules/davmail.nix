{ ... }:
{
  den.aspects.davmail = {
    homeManager = { ... }: {
      services.davmail = {
        enable = true;
        settings = {
          # Exchange Online blocks EWS from 2026-10-01 unless the tenant
          # allowlists the OAuth client's AppID, and removes it entirely on
          # 2027-04-01. Graph is the successor, but DavMail's Graph backend is
          # still beta upstream, so stay on EWS until it is proven against this
          # mailbox. To try Graph, swap the mode and add the authentication line.
          "davmail.mode" = "O365EWS";
          # "davmail.mode" = "O365Graph";

          # O365Transparent selects DavMail's O365Authenticator, the only
          # authenticator that tries the cached refresh token
          # (davmail.oauth.tokenFilePath) before anything interactive.
          # Without this set, DavMail falls back to legacy direct EWS
          # (NTLM username/password), which this tenant rejects since it's
          # OAuth-only. O365Interactive, by contrast, always forces a brand
          # new interactive browser login and never checks the cached token
          # -- unusable here anyway since there's no browser in this
          # headless systemd service.
          "davmail.authentication" = "O365Transparent";

          # Admin consent for DavMail's own AppID
          # (facd6cff-a294-4415-b59f-c5b01937d7bd) is pending with UMass, and
          # IMAP is disabled tenant-wide, so authenticate as the classic Outlook
          # desktop client instead -- the tenant already trusts it. Note shared
          # mailboxes are unreachable with this clientId (no Mail.ReadWrite.Shared).
          "davmail.oauth.clientId" = "d3590ed6-52b3-4102-aeff-aad2292ab01c";
          "davmail.oauth.redirectUri" = "urn:ietf:wg:oauth:2.0:oob";

          "davmail.oauth.tokenFilePath" = "/home/kandread/.local/share/davmail/token";
          "davmail.logFilePath" = "/home/kandread/.cache/davmail.log";
          "davmail.enableKeepAlive" = "true";

          # INFO (not the module's WARN default) so the MFA "Number matching
          # value" line -- needed to approve renewal in the Authenticator app
          # -- actually gets logged. Full DEBUG is too noisy: single log
          # lines can run to megabytes (entire login-page JSON payloads).
          "log4j.logger.davmail" = "INFO";

          # Reconciled from the interactively-bootstrapped
          # ~/.config/davmail/davmail.properties (the refresh token itself
          # lives at davmail.oauth.tokenFilePath instead, not here, so it
          # never ends up in this git-tracked file or the Nix store).
          "davmail.caldavAutoSchedule" = "true";
          "davmail.imapAutoExpunge" = "true";
          "davmail.smtpSaveInSent" = "true";
          "davmail.caldavPastDelay" = "0";
        };
      };
    };
  };
}
