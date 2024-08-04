{ pkgs, ... }:
{
  programs.adb.enable = true;
  environment.systemPackages = with pkgs; [
    PlaydateSimulator # Not in nixpkgs, overlayed by github:headblockhead/nix-playdatesdk. See flake.nix.
    asciinema
    bat
    cargo
    ccls
    cmake
    gcc
    gcc-arm-embedded
    gnumake
    go
    pass
    gopls
    inetutils
    killall
    lm_sensors
    minicom
    neofetch
    ngrok
    nixfmt-rfc-style
    nmap
    nodejs
    p7zip
    pdc # PlayDateCompiler - Not in nixpkgs, overlayed by github:headblockhead/nix-playdatesdk. See flake.nix.
    pdutil # PlayDateUtility - Not in nixpkgs, overlayed by github:headblockhead/nix-playdatesdk. See flake.nix.
    pico-sdk
    picotool
    platformio
    playdatemirror
    pulseview
    python39
    rustc
    templ
    tinygo
    tmux
    usbutils
    wireshark
    xc # Not in nixpkgs, overlayed by github:joerdav/xc. See flake.nix.
    neovim
  ];
}
