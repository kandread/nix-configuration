{ inputs, ... }:
{
  den.aspects.emacs = {
    nixos = { ... }: {
      nixpkgs.overlays = [ inputs.emacs-overlay.overlays.default ];
    };
    homeManager = { pkgs, ... }: {
      nixpkgs.overlays = [ inputs.emacs-overlay.overlays.default ];
      programs.emacs = {
        enable = true;
        package = pkgs.emacs-git-pgtk;
        extraPackages = epkgs: [
          epkgs.pdf-tools
          epkgs.jinx
          epkgs.mu4e
          epkgs.vterm
          epkgs.treesit-grammars.with-all-grammars
        ];
      };
    };
  };
}
