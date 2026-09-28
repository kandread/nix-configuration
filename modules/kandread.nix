{ den, lib, ... }:
{
  den.aspects.kandread = {
    includes = [
      den.aspects.emacs
      den.aspects.email
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
      den.aspects.direnv
      den.aspects.tmux
      (
        { host, ... }:
        lib.optionals (host.class == "nixos") [
          den.aspects.wayland
          den.aspects.desktop
          den.aspects.sway
          den.aspects.waybar
          den.aspects.river
          den.aspects.niri
          den.aspects.davmail
        ]
      )
    ];

    user =
      { host, ... }:
      {
        description = "Kostas Andreadis";
      }
      // lib.optionalAttrs (host.class == "nixos") {
        extraGroups = [ "networkmanager" "wheel" ];
      };
  };
}
