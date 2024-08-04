{
  basicConfig = import ./basicConfig.nix;
  bluetooth = import ./bluetooth.nix;
  bootloaderGraphical = import ./bootloaderGraphical.nix;
  bootloaderText = import ./bootloaderText.nix;
  cachesGlobal = import ./cachesGlobal.nix;
  desktop = import ./desktop.nix;
  desktopApps = import ./desktopApps.nix;
  development = import ./development.nix;
  docker = import ./docker.nix;
  fileSystems = import ./fileSystems.nix;
  firewall = import ./firewall.nix;
  fzf = import ./fzf.nix;
  git = import ./git.nix;
  gpg = import ./gpg.nix;
  homeManager = import ./homeManager.nix;
  network = import ./network.nix;
  sdr = import ./sdr.nix;
  sound = import ./sound.nix;
  ssd = import ./ssd.nix;
  transmission = import ./transmission.nix;
  users = import ./users.nix;
  virtualBox = import ./virtualBox.nix;
  zsh = import ./zsh.nix;
}
