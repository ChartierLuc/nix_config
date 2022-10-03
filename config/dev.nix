{ config, pkgs, lib, ... }:

{
  #virtualisation.podman.enable = true;

  environment.systemPackages = with pkgs; [
    pipenv
    python310
    python310Packages.pip
    virtualenv
    conda
  ];
}
