/*
  # Create a new MBR partition table
  parted /dev/sda --script mklabel msdos

  # Create a 512MB boot partition with ext4
  parted /dev/sda --script mkpart primary ext4 1MiB 513MiB
  parted /dev/sda --script set 1 boot on
  mkfs.ext4 -L boot /dev/sda1

  # Create a swap partition of 8GB
  parted /dev/sda --script mkpart primary linux-swap 513MiB 8577MiB
  mkswap -L swap /dev/sda2
  swapon /dev/sda2

  # Create a root partition using the rest of the disk with ext4
  parted /dev/sda --script mkpart primary ext4 8577MiB 100%
  mkfs.ext4 -L nixos /dev/sda3

  # Mount the partitions to /mnt and /mnt/boot.
  mount /dev/disk/by-label/nixos /mnt
  mkdir /mnt/boot
  mount /dev/disk/by-label/boot /mnt/boot

  # Install.
  sudo nixos-install --flake github:a-h/nixos#hetzner-builder-x86_64
*/
{ pkgs, adrianSSHKey, rootSSHKey, ... }:
let
  modprobe-blacklist = pkgs.writeText "/etc/modprobe.d/cramfs.conf" ''
    install cramfs /bin/false
  '';
in
{
  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };

  # Create a symlink from /bin/true to the Nix-managed true binary.
  # Required by modprobe-blacklist.
  environment.etc."bin/true".source = "${pkgs.coreutils}/bin/true";
  environment.etc."bin/false".source = "${pkgs.coreutils}/bin/false";

  environment.systemPackages = [
    pkgs.vim
    pkgs.git
    pkgs.zip
    pkgs.unzip
    pkgs.wget
    modprobe-blacklist
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "ext4";
  };
  # CIS 1.1.2.a - Ensure /tmp is configured
  fileSystems."/tmp" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [ "rw" "nosuid" "nodev" "noexec" "relatime" ];
  };
  swapDevices = [
    {
      device = "/dev/disk/by-label/swap";
    }
  ];

  documentation.nixos.enable = false;
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  console.keyMap = "us";
  nix.settings.trusted-users = [ "adrian" "@wheel" ];
  nix.settings.system-features = [ "kvm" "nixos-test" ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod" "ext4" ];

  boot.kernel.sysctl = {
    # CIS 3.2.9.a - Disable IPv6 Router Advertisements
    "net.ipv6.conf.all.accept_ra" = 0;
    "net.ipv6.conf.default.accept_ra" = 0;
  };

  users.users = {
    root.hashedPassword = "!"; # Disable root login
    adrian = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [
        adrianSSHKey
        rootSSHKey
      ];
    };
  };

  # CIS 1.5.1.a - Ensure core dumps are restricted
  systemd.coredump.enable = false;

  security.sudo.wheelNeedsPassword = false;

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
    # CIS 5.2 SSH Server Configuration
    extraConfig = ''
      Protocol 2
      MaxAuthTries 4
      PermitEmptyPasswords no
      PermitUserEnvironment no
      MaxSessions 4
      LoginGraceTime 60
    '';
  };
  networking.firewall.allowedTCPPorts = [ 22 ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
