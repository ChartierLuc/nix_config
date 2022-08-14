{ config, pkgs, lib, ... }:

{
  system.autoUpgrade =
  {
    enable = true;
    allowReboot = true;
  };
}
