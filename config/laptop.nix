{ config, pkgs, lib, ... }:
{
  powerManagement.cpuFreqGovernor = "powersave";
}