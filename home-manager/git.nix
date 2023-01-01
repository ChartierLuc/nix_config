{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    difftastic.enable = true;
    lfs.enable = true;
    userEmail = "luc@distorted.media";
    userName = "Luc Chartier";
    #signing.signByDefault = true;
  };
}
