{ pkgs, ... }:
{
  # Default user shell is zsh.
  users.defaultUserShell = pkgs.zsh;

  # Root user does not have zsh themes in home directory.
  users.users.root.shell = pkgs.bash;

  systemd.tmpfiles.rules = [
    "f /home/adrian/.zprofile"
  ];
  programs.nix-index.enableZshIntegration = true;
  programs.zsh = {
    # Enable zsh as a shell, add it to the environment.
    enable = true;
    autosuggestions.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" ];
    };
    shellInit = ''
            export EDITOR='vim'
            source ${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh

            # Enable vi mode for zsh.
      # See https://dougblack.io/words/zsh-vi-mode.html
      bindkey -v

      bindkey '^P' up-history
      bindkey '^N' down-history
      bindkey '^?' backward-delete-char
      bindkey '^h' backward-delete-char
      bindkey '^w' backward-kill-word
      bindkey '^r' history-incremental-search-backward
      bindkey '^a' beginning-of-line
      bindkey '^e' end-of-line
      bindkey "^[[3~" delete-char
      # On OSX, might need to update the terminal to send home and end as ctrl-a, ctrle.

      # number of jobs, return code of previous command, current directory, % if not root, or # if root.
      PROMPT="%j %? %d %# "
      RPROMPT=""
      # Ensure that the prompt doesn't overwrite output that doesn't terminate with a new line.
      setopt PROMPT_SP

      export KEYTIMEOUT=1

      # Enable colours in ls etc.
      export CLICOLOR=1
      export LSCOLORS=gxfxcxdxbxgggdabagacad

      # Get rid of telemetry.
      export SAM_CLI_TELEMETRY=0
      export DOTNET_CLI_TELEMETRY_OPTOUT=1

      # Go module proxies mess with private repos. Waiting for https://github.com/golang/go/issues/33985
      export GONOSUMDB=*

      # Create an alias for listening.
      listening() {
          if [ $# -eq 0 ]; then
              sudo lsof -iTCP -sTCP:LISTEN -n -P
          elif [ $# -eq 1 ]; then
              sudo lsof -iTCP -sTCP:LISTEN -n -P | grep -i --color $1
          else
              echo "Usage: listening [pattern]"
          fi
      }

      # The next line updates PATH for the Google Cloud SDK.
      if [ -f '/Users/adrian/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/adrian/google-cloud-sdk/path.zsh.inc'; fi

      # The next line enables shell command completion for gcloud.
      if [ -f '/Users/adrian/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/adrian/google-cloud-sdk/completion.zsh.inc'; fi

      # Automatically configure direnv.
      eval "$(direnv hook zsh)"

    '';
    shellAliases = {
      q = "exit";
      ls = "ls --color=tty -A";
      gs = "git status -s";
      gl = ''
        git log --pretty=format:"%C(yellow)%h\\ %ad%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --date=short
      '';
      gd = "git diff";
      gp = "git push";
      gu = "git pull";
      gcp = "git commit && git push";
      gaacp = ''
        git add --all && git status && printf "%s " "Press enter to continue" && read ans && git commit && git push"
      '';
    };
  };
}
