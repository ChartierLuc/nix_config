{ config, pkgs, ... }:
{

  environment.variables = {
    EDITOR = "vim";
    LC_ALL = "en_US.UTF-8";
    TERM = "xterm-256color";
  };

  environment.shells = [ pkgs.zsh ];
  environment.systemPackages = [
    pkgs.neovim
    pkgs.git
    pkgs.synergyWithoutGUI
    pkgs.tikzit
    pkgs.tectonic
    pkgs.alacritty
    pkgs.texlive.combined.scheme-full
    pkgs.ranger
    pkgs.ripgrep
    pkgs.yarn
    pkgs.stripe-cli
  ];

  # Make sure the nix daemon always runs
  services.nix-daemon.enable = true;
  # Installs a version of nix, that dosen't need "experimental-features = nix-command flakes" in /etc/nix/nix.conf
  #services.nix-daemon.package = pkgs.nixFlakes;
  nix.package = pkgs.nix;

  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;

    casks = [
      # "libsodium"
      # "cmake"
      # "stripe/stripe-cli/stripe"
    ];
  };
  
  networking = {
    computerName = "Luc Air";
    hostName = "Air";
  };

  programs.tmux = {
    enable = true;
    #enableFzf = true;
    #enableMouse = true;
    #enableSensible = false;
    #enableVim = false;
  };

  programs.zsh = {
    enable = true; 
  };

  security.pam.enableSudoTouchIdAuth = true;
}
