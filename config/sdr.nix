{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    cubicsdr
    gnuradio
    gqrx
    limesuite
    sdrangel
  ];
}