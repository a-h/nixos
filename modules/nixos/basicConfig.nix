{
  # Clear the tmp directory on boot.
  boot.tmp.cleanOnBoot = true;

  # Disable nixos-help apps.
  documentation.nixos.enable = false;

  # Set regonal settings.
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  console.keyMap = "us";

  # Set the trusted users.
  nix.settings.trusted-users = [ "adrian" ];
}
