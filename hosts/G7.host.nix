{ config, builtins, lib, pkgs, modulesPath, ... }:

{
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  time.timeZone = "NewYork/America";

  # SSD health
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/8c9c55d3-82c6-4d7b-b468-6dc92ff4c1bc";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/CC43-38E5";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/2372eb49-3cfa-4e1b-b0ee-41fd87617dde"; }
    ];

  boot.initrd.luks.devices.luksroot = {
      device = "/dev/disk/by-uuid/ff13d863-af23-4d69-bd64-b28a0de4ddb6";
      preLVM = true;
      allowDiscards = true;
  };

  programs.ssh.startAgent = false;
  # programs.dconf.enable = true;

  hardware.bluetooth.enable = true;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.pulseaudio.enable = false;

  services.xserver = {
    videoDrivers = [ "modesetting" ];
    useGlamor = true;
  };

  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;

  environment.variables = {
    BROWSER = "firefox";
    TERMINAL = "alacritty";
  };

  environment.systemPackages = with pkgs; [
    #brave
    #discord
    firefox
    riced-alacritty
    gnome3.eog
    pavucontrol
    vlc
    xdg-utils # Multiple packages depend on xdg-open at runtime. This includes Discord and JetBrains
    chromium
    #exodus
    #rnix-lsp
    #distrobox
    #obs-studio
    gnomeExtensions.hide-top-bar
    gnomeExtensions.burn-my-windows  
    ];

  networking.firewall.checkReversePath = "loose";

  environment.shellAliases = {
    vv = "${pkgs.neovim-unwrapped}/bin/nvim";
  };
}
