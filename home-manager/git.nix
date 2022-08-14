{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    difftastic.enable = true;
    lfs.enable = true;
    userEmail = "luc@distorted.audio";
    userName = "Luc Chartier";
    #signing.signByDefault = true;
  };
}
