{ ... }:
{
  den.aspects.librewolf = {
    homeManager = { pkgs, ... }: {

      programs.librewolf = {
	enable = true;
	profiles.kandread = {
	  isDefault = true;
	  extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
	    multi-account-containers
	    proton-pass
	    proton-vpn
	    zotero-connector
	    canvasblocker
	  ];
	  containers = {
	    personal = {
	      id = 1;
	      color = "blue";
	      icon = "circle";
	    };
	    work = {
	      id = 2;
	      color = "orange";
	      icon = "briefcase";
	    };
	  };
	  containersForce = true;
	};
	settings = {
	  "webgl.prompt" = false;
	};
	# LibreWolf clears cookies on shutdown. Origins listed here get a
	# permanent "allow" cookie permission, which is exempt from that
	# clearing, so their cookies (and logins) persist across sessions.
	# Use full origins, e.g. "https://github.com".
	policies.Cookies.Allow = [
          "https://claude.ai"
          "https://github.com"
          "https://mail.proton.me"
          "https://accounts.google.com"
          "https://login.microsoftonline.com"
	];
      };
    };
  };
}
