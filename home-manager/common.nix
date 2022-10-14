{ pkgs, lib, config, ... }:

with lib;
with pkgs;
let
  browser = [ "firefox.desktop" ];
  #browser = [ "chromium-browser.desktop" ];
  #browser = [ "brave-browser.desktop" ];
  # associations = {
  #   "text/html" = browser;
  #   "x-scheme-handler/http" = browser;
  #   "x-scheme-handler/https" = browser;
  #   "x-scheme-handler/ftp" = browser;
  #   "x-scheme-handler/chrome" = browser;
  #   "x-scheme-handler/about" = browser;
  #   "x-scheme-handler/unknown" = browser;
  #   "application/x-extension-htm" = browser;
  #   "application/x-extension-html" = browser;
  #   "application/x-extension-shtml" = browser;
  #   "application/xhtml+xml" = browser;
  #   "application/x-extension-xhtml" = browser;
  #   "application/x-extension-xht" = browser;

  #   #"text/*" = [ "emacs.desktop" ];
  #   "audio/*" = [ "vlc.desktop" ];
  #   "video/*" = [ "vlc.dekstop" ];
  #   #"image/*" = [ "ahoviewer.desktop" ];
  #   #"text/calendar" = [ "thunderbird.desktop" ]; # ".ics"  iCalendar format
  #   "application/json" = browser; # ".json"  JSON format
  #   "application/pdf" = browser; # ".pdf"  Adobe Portable Document Format (PDF)
  #   # "x-scheme-handler/tg" = "userapp-Telegram Desktop-95VAQ1.desktop";
  # };

in
{
  home.stateVersion = "22.05";
  # home.keyboard.options = [ "terminate:ctrl_alt_bksp" "caps:escape" "altwin:swap_alt_win" ];

  services.network-manager-applet.enable = true;

  home.sessionVariables = {
    BROWSER = "firefox";
    TERMINAL = "alacritty";
    NIXPKGS_ALLOW_UNFREE = 1;
  };

  # xdg.mimeApps.enable = true;
  # xdg.mimeApps.associations.added = associations;
  # xdg.mimeApps.defaultApplications = associations;

  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
    iconTheme.package = pkgs.papirus-icon-theme;
    iconTheme.name = "ePapirus";
    theme.package = pkgs.mojave-gtk-theme;
    theme.name = "Mojave-Dark";
    font.name = "Roboto";
    font.package = pkgs.ibm-plex;
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-button-images = false;
      gtk-menu-images = false;
      gtk-toolbar-style = "GTK_TOOLBAR_ICONS";
    };
  };

  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      vim-airline
      vim-nix
    ];
   extraConfig = ''
     set mouse=a
   '';
  };

  home.packages = with pkgs; [
    xdg-utils # Multiple packages depend on xdg-open at runtime. This includes Discord and JetBrains
    gnome.nautilus
#    rice-firefox
    # rice-alacritty
    gnome.eog
 #   pavucontrol
    #vlc
    neofetch
    # whiplash-gtk-theme
    solarc-gtk-theme
    mojave-gtk-theme
    gtk-engine-murrine
    gtk_engines
    vscode
    nextcloud-client
  ];

  systemd.user.services.polkit-gnome = {
    Unit = {
      Description = "PolicyKit Authentication Agent";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    extensions = with pkgs.vscode-extensions; [
        dracula-theme.theme-dracula
        jnoortheen.nix-ide
        #bbenoist.Nix
        justusadam.language-haskell
    ];
    userSettings = {
      "window.titleBarStyle"="custom";
      #"terminal.integrated.fontFamily" = "Hack";
    };
};
}
