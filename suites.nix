{ utils }:
let
  nixosModules = utils.lib.exportModules [
    ./config/base-desktop.nix
    ./config/cli.nix
    ./config/personal.nix
    ./config/dev.nix
    ./config/xorg.nix
    ./config/oled.nix
 ];

  sharedModules = with nixosModules; [
    personal

   {
     home-manager.useGlobalPkgs = true;
     home-manager.useUserPackages = true;
   }
  ];

  desktopModules = with nixosModules; [
    base-desktop
    xorg
    cli
    oled

    ({ pkgs, lib, config, ...}: {
      nix.generateRegistryFromInputs = true;
      nix.linkInputs = true;
      boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
      nixpkgs.config.allowBroken = false;
      hardware.bluetooth.enable = true;
    })
  ];
in
{
  inherit nixosModules sharedModules desktopModules;
}
