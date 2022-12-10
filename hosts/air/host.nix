{ config, pkgs, ... }:
{

  environment.systemPackages = 
  [
    pkgs.vim
    pkgs.tmux
    pkgs.git
    pkgs.synergy
  ];

  # Make sure the nix daemon always runs
  services.nix-daemon.enable = true;
  # Installs a version of nix, that dosen't need "experimental-features = nix-command flakes" in /etc/nix/nix.conf
  #services.nix-daemon.package = pkgs.nixFlakes;
  nix.package = pkgs.nix;

  # if you use zsh (the default on new macOS installations),
  # you'll need to enable this so nix-darwin creates a zshrc sourcing needed environment changes
  programs.zsh.enable = true;
  # bash is enabled by default

  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;

    casks = [
      # "libsodium"
      # "cmake"
    ];
  };
}
