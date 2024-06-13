{ pkgs, ... }:
{
imports = [];
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    bat
    devbox
    tmux
    curl
    entr
    exa
    fd
    file
    fzf
    gcc
    git
    git-lfs
    htop
    inetutils
    iotop
    lm_sensors
    lshw
    lsof
    man
    nettools
    nix-tree
    nixpkgs-fmt
    nushell
    p7zip
    parted
    pciutils
    psmisc
    pure-prompt
    ranger
    ripgrep
    rustup
    unzip
    wget
    which
    zip
    vim
    neovim
    yubikey-agent
    yubikey-manager
    yubikey-personalization
    efibootmgr
    nix-index
  ];
}
