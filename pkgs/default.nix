# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{ pkgs, inputs }: {
  go = pkgs.callPackage ../custom-packages/go.nix { };
  pdc = inputs.playdatesdk.packages.x86_64-linux.pdc;
  pdutil = inputs.playdatesdk.packages.x86_64-linux.pdutil;
  PlaydateSimulator = inputs.playdatesdk.packages.x86_64-linux.PlaydateSimulator;
  playdatemirror = inputs.playdatemirror.packages.x86_64-linux.Mirror;
  xc = inputs.xc.packages.x86_64-linux.xc;
  home-manager = inputs.home-manager.defaultPackage.x86_64-linux;
  templ = inputs.templ.packages.x86_64-linux.default;
}
