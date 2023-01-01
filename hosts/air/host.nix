{ config, pkgs, ... }:
{

  environment.shells = [ pkgs.zsh ];
  environment.systemPackages = [
    pkgs.vim
    pkgs.git
    pkgs.synergyWithoutGUI
    pkgs.tikzit
    pkgs.tectonic
    pkgs.alacritty
    #pkgs.texlive.combined.scheme-full
  ];
  #environment.variables = [];

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
      #"alacritty"
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
