{ system, inputs, ... }: {
  overlays = self: super: {
    nix = inputs.nix.packages.${system}.nix;
  };
}
