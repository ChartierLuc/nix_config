{ config, lib, pkgs, ... }:

{
  # Make qt apps look like gtk apps
  qt5.enable = true;
  qt5.platformTheme = "gtk2";
  qt5.style = "gtk2";
  
   services.xserver = {
    enable = true;
    layout = "us";
    displayManager.gdm.enable = true;
    displayManager.gdm.wayland = false;
    desktopManager.gnome.enable = true;
   };

   environment.systemPackages = with pkgs; [
    solarc-gtk-theme
    gtk-engine-murrine
    gtk_engines
  ];

  # xdg.mime.enable = true;
  # environment.systemPackages = with pkgs; [ xclip ];

  # # fonts.fonts = with pkgs; [ nerdfonts noto-fonts-emoji noto-fonts ];
  # services.xserver = {
  #   enable = true;
  #   layout = "us";
  #   xkbOptions = "terminate:ctrl_alt_bksp,caps:escape,altwin:swap_alt_win";
  #   libinput = {
  #     enable = true;
  #     # Left + right click emulates middle button.
  #     middleEmulation = true;
  #     #naturalScrolling = true;
  #   };

  #   # Make auto-repeat on key hold work faster.
  #   displayManager.xserverArgs = [
  #     "-ardelay 300"
  #     "-arinterval 20"
  #   ];

  #   displayManager.lightdm = {
  #     enable = true;
  #     greeters.enso.enable = true;
  #     greeters.enso.theme.name = "Numix";
  #     greeters.enso.theme.package = pkgs.numix-gtk-theme;

  #     #background
  #     #greeters.enso.blur
  #     #greeters.enso.brightness
  #     #greeters.enso.cursorTheme.name
  #     #greeters.enso.cursorTheme.package
  #     #greeters.enso.extraConfig
  #     #greeters.enso.iconTheme.name
  #     #greeters.enso.iconTheme.package
  #   };
  # };

  # TODO: Does not work well 20.09, needs to be fixed at some point
  # To make sure all local SSH sessions are closed after a laptop lid is shut.
  #powerManagement.powerDownCommands = ''
  #{pkgs.procps}/bin/pgrep ssh | IFS= read -r pid; do
  # "$(readlink "/proc/$pid/exe")" = "${pkgs.openssh}/bin/ssh" ] && kill "$pid"
  #one
  #'';

}
