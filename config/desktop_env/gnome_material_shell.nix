{ config, lib, pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.gnomeExtensions.material-shell
  ];
}