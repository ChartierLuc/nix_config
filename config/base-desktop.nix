{ config, pkgs, lib, ... }:
{
  console.keyMap = "us";
  fileSystems."/boot".label = "BOOT";
  i18n.defaultLocale = "en_US.UTF-8";
  system.stateVersion = "22.05";
  nixpkgs.config.allowUnfree = true;

  systemd.tmpfiles.rules = [
    "L+ /lib64/ld-linux-x86-64.so.2 - - - - ${pkgs.glibc}/lib64/ld-linux-x86-64.so.2"
  ];

  # Limits start limit burst to 1sec instead of 5 since it was causing issues with rapid logout/login and units restart
  systemd.user.extraConfig = ''
    DefaultStartLimitBurst=1
  '';

  networking = {
    firewall.enable = true;
    #firewall.allowedTCPPorts = [ 8080 9090 ];
    firewall.allowPing = false;
    hostId = builtins.substring 0 8 (builtins.hashString "md5" config.networking.hostName);
    nameservers = [ "1.1.1.1" ];
    useDHCP = false;
    networkmanager.enable = true;
  };

  programs.ssh.startAgent = false;

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 40d";
    dates = "weekly";
  };

  boot = {
    # Imporved networking
    kernelModules = [ "tcp_bbr" ];
    kernel.sysctl."net.ipv4.tcp_congestion_control" = "bbr";
    kernel.sysctl."net.core.default_qdisc" = "fq";

    kernel.sysctl = {
      "vm.swappiness" = 5;
      "fs.inotify.max_user_watches" = 524288;
    };
    #zfs.enableUnstable = true;
    kernelParams = [ "quiet" "loglevel=3" ];
    cleanTmpDir = true;

    loader.grub.enable = true;
    loader.grub.version =2;

    loader.grub.efiSupport = true;
    loader.timeout = 2;
    loader.efi.canTouchEfiVariables = true;
    loader.grub.gfxmodeEfi = "1024x768";
    tmpOnTmpfs = true;
  };

  services = {
    dbus.packages = with pkgs; [ dconf ];
    zfs.autoSnapshot.enable = true;
    zfs.autoScrub.enable = true;
    printing.enable = true;
    # tlp.enable = true;
  };

  programs.dconf.enable = true;

  virtualisation.libvirtd.enable = true;


  fonts = {
    enableDefaultFonts = true;
    fonts = [ pkgs.nerdfonts ];
  };

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
    settings = {
      trusted-users = [ "root" "luc" ];
      auto-optimise-store = true;
    };
  };

  environment.systemPackages = with pkgs; [
    firefox
    thunderbird
    alacritty
    xdg-utils # Multiple packages depend on xdg-open at runtime. This includes Discord and JetBrains
    gnome.eog
    pavucontrol
    keepassxc
    emacs
    yubikey-manager-qt
    yubikey-personalization-gui
    virt-manager
    obsidian
    texlive.combined.scheme-full
    gimp
    imagemagick
    conda
    nvtop
  ];

  environment.variables = {
    BROWSER = "firefox";
    TERMINAL = "alacritty";
  };

}
