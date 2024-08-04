{ pkgs, ... }: {
  home.packages = with pkgs; [
    gh
    git-lfs
    git
  ];
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
      editor = "";
      pager = "";
      http_unix_socket = "";
      browser = "";
    };
  };
  programs.git = {
    enable = true;
    userName = "Adrian Hesketh";
    userEmail = "adrianhesketh@hushmail.com";
    difftastic = {
      enable = true;
      background = "dark";
      display = "inline";
    };
    signing = {
      key = "22323123";
      gpgPath = "/run/current-system/sw/bin/gpg2";
      signByDefault = true;
    };
    extraConfig = { pull.rebase = false; commit.gpgsign = true; };
  };

}
