{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    arduino
    audacity
    firefox
    fractal # matrix messenger
    gimp
    google-chrome
    libreoffice
    remmina
    spotify
    slack
    thonny
    thunderbird
    transgui
    unstable.rpi-imager
    vlc
  ];
}
