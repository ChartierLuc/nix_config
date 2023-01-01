{ pkgs, ... }:
{
  imports = [
    ./common-macos.nix
    ./alacritty.nix
    ./git.nix
    ];
  home.stateVersion = "22.11";
}