{ config, pkgs, lib, ... }:
{
  #powerManagement.powertop.enable = true;
  powerManagement.cpuFreqGovernor = "performance";
  console.keyMap = "us";
  fileSystems."/boot".label = "BOOT";
  i18n.defaultLocale = "en_US.UTF-8";
  nix.settings.auto-optimise-store = true;
  system.stateVersion = "22.05";

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

  environment.systemPackages = [ pkgs.bluez ];

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
    loader.grub.device = "nodev";
    loader.grub.efiSupport = true;
    loader.timeout = 2;
    loader.efi.canTouchEfiVariables = true;
    loader.grub.gfxmodeEfi = "1024x768";
    tmpOnTmpfs = true;
  };

   services.xserver = {
    enable = true;
    layout = "us";
    displayManager.gdm.enable = true;
    displayManager.gdm.wayland = false;
    desktopManager.gnome.enable = true;
   };

  services = {
    dbus.packages = with pkgs; [ dconf ];
    zfs.autoSnapshot.enable = true;
    zfs.autoScrub.enable = true;
    openssh.enable = false;
    openssh.passwordAuthentication = false;
    printing.enable = true;
    # tlp.enable = true;
  };
  services.xserver.deviceSection = ''
    Option "VariableRefresh" "true"
  '';

  programs.dconf.enable = true;


  fonts = {
    enableDefaultFonts = true;
    fonts = [ pkgs.nerdfonts ];
  };


  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware = {
    enableRedistributableFirmware = true;
    enableAllFirmware = true;
    opengl = {
      enable = lib.mkDefault true;
      driSupport32Bit = config.hardware.opengl.enable;
      #extraPackages = with pkgs; [
      #  rocm-opencl-icd
      #  rocm-opencl-runtime
      #  amdvlk
      #];
      #extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];
    };
    cpu.intel.updateMicrocode = true;
  };
}
