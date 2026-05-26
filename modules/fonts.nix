{ ... }:
{
  den.aspects.fonts = {
    nixos = { pkgs, ... }: {
 nixpkgs.config = {
        joypixels.acceptLicense = true;
      };
      fonts.packages = with pkgs; [
        nerd-fonts.meslo-lg
        nerd-fonts.inconsolata-lgc
        nerd-fonts.roboto-mono
        nerd-fonts.symbols-only
        nerd-fonts.geist-mono
        fg-virgil
        font-awesome
        fira
        fira-math
        fira-code
        hack-font
        raleway
        lato
        joypixels
        aporetic
      ];
    };
  };
}
