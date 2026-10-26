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
      den.aspects.alacritty
      den.aspects.foot
      den.aspects.fish
      den.aspects.calendar
      den.aspects.llm
      den.aspects.pdf
      den.aspects.media
      den.aspects.gimp
      den.aspects.gpg
      den.aspects.firefox
      den.aspects.librewolf
      den.aspects.qutebrowser
      den.aspects.chromium
      den.aspects.science
      den.aspects.theming
      den.aspects.wayland
      den.aspects.desktop
      den.aspects.sway
      den.aspects.waybar
      den.aspects.river
      den.aspects.dwl
      den.aspects.niri
      den.aspects.eww
      den.aspects.direnv
      den.aspects.tmux
      den.aspects.syncthing
    ];

    user = { ... }: {
      extraGroups = [ "networkmanager" "wheel" ];
      description = "Kostas Andreadis";
    };
  };
}
