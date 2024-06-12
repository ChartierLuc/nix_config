{ pkgs, ... }:
{
imports = [./common-headless.nix ./git.nix ./neovim.nix];
  home.stateVersion = "22.11";
}
