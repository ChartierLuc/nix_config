{ pkgs, lib, config, ... }:

{
  # home.keyboard.options = [ "terminate:ctrl_alt_bksp" "caps:escape" "altwin:swap_alt_win" ];

  # Htop
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.htop.enable
  programs.htop.enable = true;
  programs.htop.settings.show_program_path = true;
  
  home.sessionVariables = {
    TERMINAL = "alacritty";
    NIXPKGS_ALLOW_UNFREE = 1;
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
    neofetch
    # vscode
    # nextcloud-client
  ];

  # programs.vscode = {
  #   enable = true;
  #   package = pkgs.vscode;
  #   extensions = with pkgs.vscode-extensions; [
  #       dracula-theme.theme-dracula
  #       jnoortheen.nix-ide
  #       #bbenoist.Nix
  #       justusadam.language-haskell
  #   ];
  #   userSettings = {
  #     "window.titleBarStyle"="custom";
  #     #"terminal.integrated.fontFamily" = "Hack";
  #   };
  # };
}
