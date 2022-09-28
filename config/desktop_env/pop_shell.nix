{ config, lib, pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.gnomeExtensions.pop-shell
    pkgs.pop-gtk-theme
  ];
}