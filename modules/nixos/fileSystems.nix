{
  fileSystems."/" =
    {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };

  swapDevices =
    [{ device = "/var/swapfile"; size = 5120; options = [ "nofail" "x-systemd.device-timeout=3s" ]; }];

}
