{
  baseConfig = import ./baseConfig.nix;
  dconf = import ./dconf.nix;
  fzf = import ./fzf.nix;
  git = import ./git.nix;
  gnomeTerminal = import ./gnomeTerminal.nix;
  gtk = import ./gtk.nix;
  nautilusBookmarks = import ./nautilusBookmarks.nix;
  neovim = import ./neovim.nix;
  zsh = import ./zsh.nix;
}
