{ config, pkgs, lib, ... }:

{
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
  
  environment.systemPackages = with pkgs; [
    docker-compose
  ];
}
