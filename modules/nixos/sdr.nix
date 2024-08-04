{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.cubicsdr
  ];
  hardware.rtl-sdr.enable = true;
  users.users.adrian.extraGroups = [ "plugdev" ];
}
