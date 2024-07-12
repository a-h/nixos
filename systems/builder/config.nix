{ pkgs, adrianSSHKey, rootSSHKey, ... }:

{
  networking.hostName = "builder";

  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };

  environment.systemPackages = [
    pkgs.vim
    pkgs.git
    pkgs.zip
    pkgs.unzip
    pkgs.wget
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };
  swapDevices = [
    {
      device = "/dev/disk/by-label/swap";
    }
  ];

  documentation.nixos.enable = false;
  boot.tmp.cleanOnBoot = true;
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  console.keyMap = "us";
  nix.settings.trusted-users = [ "adrian" "@wheel" ];
  nix.settings.system-features = [ "kvm" "nixos-test" ];

  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      systemd-boot = {
        enable = true;
      };
    };
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

  security.sudo.wheelNeedsPassword = false;

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };
  networking.firewall.allowedTCPPorts = [ 22 ];

  # Enable qemu agent so that running `utmctl ip-address <name>` from the host works.
  virtualisation.qemu.guestAgent.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
