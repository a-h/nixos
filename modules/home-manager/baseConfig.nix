{ pkgs, ... }:
{
  # Don't show home-manager news
  news.display = "silent";
  news.entries = pkgs.lib.mkForce [ ];
  manual.manpages.enable = false;
}
