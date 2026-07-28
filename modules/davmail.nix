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
          # "davmail.authentication" = "O365Interactive";

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
        };
      };
    };
  };
}
