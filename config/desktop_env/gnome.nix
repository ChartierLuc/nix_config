{ config, pkgs, lib, ... }:
{
  # Make qt apps look like gtk apps
  qt5.enable = true;
  qt5.platformTheme = "gnome";
  qt5.style = "adwaita-dark";
  
  services.xserver = {
    enable = true;
    layout = "us";
    displayManager.gdm.enable = true;
    displayManager.gdm.wayland = true;
    desktopManager.gnome.enable = true;
   };

   environment.systemPackages = with pkgs; [
    solarc-gtk-theme
    mojave-gtk-theme
    gnomeExtensions.emoji-selector
    gtk-engine-murrine
    gtk_engines
  ];
}