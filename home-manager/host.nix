{ config, builtins, lib, pkgs, modulesPath, ... }:
{
  nixpkgs.config.allowUnfree = true;
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" "amdgpu" "usbhid" ];  
  boot.initrd.kernelModules = [ "dm-snapshot" "amdgpu" ];
  boot.kernelModules = [  "nvidia" "kvm-amd" ];
  boot.loader.grub.device = "nodev";
  
  ## Bootloader.
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  # enable the nvidia driver
  services.xserver.videoDrivers = [ "nvidia" "amdgpu" ];
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  
  # SSD health
  #fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  boot.extraModulePackages = [ pkgs.linuxPackages.nvidia_x11 ];
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/e190b08d-cac6-44ee-9372-a0f8c4b163a8";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/32EE-136B";
      fsType = "vfat";
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  #networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp1s0.useDHCP = lib.mkDefault true;

  networking.useDHCP = lib.mkDefault true;
  networking.hostName = "frieza";

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;
  services.xserver.libinput.enable = true;

  # # enable nvidia driver
  # services.xserver.videoDrivers = [ "nvidia" "amdgpu" ];
  # hardware.opengl.enable = true;
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  
environment.shellAliases = {
  deffyodds = "cd /home/luc/Documents/git_repos/ai/deffy-odds";
  nixconfig = "cd /home/luc/Documents/nix_config";

  rebuild = "nixos-rebuild switch --use-remote-sudo --flake /home/luc/Documents/nix_config#frieza";
};

hardware = {
  enableRedistributableFirmware = true;
  enableAllFirmware = true;
  opengl = {
    extraPackages = with pkgs; [
      rocm-opencl-icd
      rocm-opencl-runtime
      amdvlk
    ];
    extraPackages32 = with pkgs; [ driversi686Linux.amdvlk];
  };
};
  users.users.cloudflared = {
    group = "cloudflared";
    isSystemUser = true;
  };
  users.groups.cloudflared = { };

  systemd.services.my_tunnel = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" "systemd-resolved.service" ];
    serviceConfig = {
      ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token=eyJhIjoiOGY4NmYwYjUxOGFmZWZmZjU4ZDUxNWZlMmEyNTNiMzMiLCJ0IjoiZjZkMWIyNTgtM2M3NC00ZGUwLWFhZmItZmU5ZTIzZTYzZjdhIiwicyI6Ik5qSXhNekl6WmpRdE5EQXpZUzAwWldaaExUZzFZekV0WVdWa056RXpPV1JoTkRFNCJ9";
      Restart = "always";
      User = "cloudflared";
      Group = "cloudflared";
    };
  };
}
