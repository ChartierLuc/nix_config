{ config, pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    pkgs.emacs
    pkgs.firefox
  ];
}