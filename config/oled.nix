{ config, pkgs, lib, ... }:
{
 environment.systemPackages = with pkgs; [
    gnomeExtensions.hide-top-bar
    gnomeExtensions.burn-my-windows  
  ];
}
