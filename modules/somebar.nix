{ ... }:
{
  # dwm-like bar for dwl. It is launched by dwl itself (`dwl -s somebar`, see
  # modules/dwl.nix) so it can read dwl's state from stdin.
  den.aspects.somebar = {
    nixos = { pkgs, ... }: {
      # Overlay so modules/dwl.nix picks up the patched package too. Tags that
      # have no clients and aren't selected or urgent are not drawn; a hidden
      # tag still gets an x so the click lookup keeps working.
      nixpkgs.overlays = [
        (final: prev: {
          somebar = prev.somebar.overrideAttrs (old: {
            postPatch = (old.postPatch or "") + ''
              substituteInPlace src/bar.cpp --replace-fail \
                'for (auto &tag : _tags) {' \
                'for (auto &tag : _tags) {
              if (tag.numClients == 0 && !(tag.state & (TagState::Active | TagState::Urgent))) {
                tag.component.x = _x;
                continue;
              }'
            '';
          });
        })
      ];
      environment.systemPackages = [ pkgs.somebar ];
    };
  };
}
