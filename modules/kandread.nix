{ den, ... }:
{
  den.aspects.kandread = {
    includes = [
    den.aspects.emacs
    den.aspects.email
    den.aspects.davmail
    den.aspects.git
    den.aspects.ssh
    den.aspects.writing
    den.aspects.utilities
    den.aspects.devel
    den.aspects.comms
    den.aspects.kitty
    den.aspects.fish
    den.aspects.calendar
    den.aspects.llm
    den.aspects.pdf
    den.aspects.media
    den.aspects.gpg
    den.aspects.firefox
    den.aspects.science
    den.aspects.theming
    den.aspects.wayland
    den.aspects.mango
    ];

    user = { ... }: {
      extraGroups = [ "networkmanager" "wheel" ];
      description = "Kostas Andreadis";
    };
  };
}
