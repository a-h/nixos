{
  users.users = {
    root.hashedPassword = "!"; # Disable root login
    adrian = {
      description = "Adrian Hesketh";
      isNormalUser = true;
      extraGroups =
        [ "wheel" "adbusers" "dialout" "transmission" "docker" ];
    };
  };
}
