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
      };
    };
  };
}
