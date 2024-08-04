{ outputs
, pkgs
, ...
}:
{
  imports = with outputs.homeManagerModules; [
    baseConfig
    dconf
    fzf
    git
    gnomeTerminal
    gtk
    nautilusBookmarks
    neovim
    zsh
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "adrian";
  home.homeDirectory = "/home/adrian";
  home.enableNixpkgsReleaseCheck = true;

  services.gpg-agent = {
    enable = true;
    enableScDaemon = true;
    enableSshSupport = true;
    sshKeys = [ "FFC73CEA6D1594D7F473F1FB0ED190BDE0909FE2" ];
    pinentryPackage = pkgs.pinentry-tty;
  };

  home.packages = [
    pkgs.air # Hot reload for Go.
    pkgs.d2 # Diagramming
    pkgs.upterm
    pkgs.xc # Task executor.
    # Java development.
    pkgs.jdk # Development.
    #BROKE pkgs.openjdk17 # Development.
    pkgs.jre # Runtime.
    pkgs.gradle # Build tool.
    pkgs.jdt-language-server # Language server.
    pkgs.maven
    # Other.
    pkgs.aerc
    pkgs.aha # Converts shell output to HTML.
    pkgs.adwaita-qt # QT theme to bend Qt applications to look like they belong into GNOME Shell
    pkgs.expect # Provides the unbuffer command used to force programs to pipe color: `unbuffer fd | aha -b -n` (https://joshbode.github.io/remark/ansi.html#5)
    pkgs.bat
    pkgs.silver-searcher
    pkgs.asciinema
    pkgs.astyle # Code formatter for C.
    pkgs.aws-vault
    pkgs.awscli2
    pkgs.awslogs
    pkgs.ccls # C LSP Server.
    pkgs.cmake # Used by Raspberry Pi Pico SDK.
    pkgs.cargo # Rust tooling.
    pkgs.delve # Go debugger.
    pkgs.direnv # Support loading environment files, and the use of https://marketplace.visualstudio.com/items?itemName=mkhl.direnv
    pkgs.docker
    pkgs.dynamotableviz
    pkgs.dotnet-sdk # No Darwin ARM support.
    pkgs.entr # Execute command when files change.
    pkgs.fd # Find that respects .gitignore.
    pkgs.fzf # Fuzzy search.
    # pkgs.gcalcli # Google Calendar CLI.
    pkgs.gcc
    pkgs.gcc-arm-embedded # Raspberry Pi Pico GCC. # No Darwin ARM support.
    pkgs.gifsicle
    pkgs.git
    pkgs.git-lfs
    pkgs.gitAndTools.gh
    pkgs.gnomeExtensions.appindicator
    pkgs.gnomeExtensions.hide-top-bar
    pkgs.gnupg
    pkgs.go
    pkgs.go-swagger
    pkgs.gomuks
    pkgs.gotools
    pkgs.google-cloud-sdk # No Darwin ARM support.
    pkgs.gopls
    pkgs.graphviz
    pkgs.html2text
    pkgs.htop
    pkgs.hugo
    pkgs.ibm-plex
    pkgs.imagemagick
    pkgs.jq
    pkgs.libvirt
    pkgs.virt-manager
    pkgs.lua5_4
    pkgs.lua-language-server
    pkgs.llvm # Used by Raspberry Pi Pico SDK.
    pkgs.lynx
    pkgs.mob
    pkgs.minicom # Serial monitor.
    pkgs.mutt
    pkgs.nil # Nix Language Server.
    pkgs.nix # Specific version of Nix.
    pkgs.ninja # Used by Raspberry Pi Pico SDK, build tool.
    pkgs.nixpkgs-fmt
    pkgs.nix-prefetch-git
    pkgs.nmap
    pkgs.nodePackages.node2nix
    pkgs.nodePackages.prettier
    #pkgs.nodePackages.typescript
    #pkgs.nodePackages.typescript-language-server
    pkgs.nodejs-18_x
    pkgs.pass
    pkgs.powerline
    pkgs.python310Packages.python-lsp-server
    pkgs.podman
    pkgs.source-code-pro
    pkgs.ripgrep
    pkgs.rustc # Rust compiler.
    pkgs.rustfmt # Rust formatter.
    pkgs.rust-analyzer # Rust language server.
    pkgs.ssm-session-manager-plugin # No Darwin ARM support. 
    pkgs.slides
    pkgs.terraform
    pkgs.terraform-ls
    pkgs.tflint
    pkgs.tmate
    pkgs.tmux
    pkgs.tree
    pkgs.unzip
    pkgs.urlscan
    pkgs.wl-clipboard # wayland clipboard
    pkgs.wget
    pkgs.xclip
    pkgs.yaml-language-server
    pkgs.yarn
    pkgs.zip
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

