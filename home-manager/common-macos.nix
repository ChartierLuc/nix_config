{ pkgs, lib, config, langchain-nvim, ... }:
let
  langchainPlugin = pkgs.callPackage /Users/luc/code/langchain-nvim/default.nix {};
  langchain = pkgs.callPackage /Users/luc/code/langchain-nvim/langchain.nix { 
    buildPythonPackage=pkgs.python3Packages.buildPythonPackage;
    tenacity = pkgs.python310Packages.tenacity;
    dataclasses-json = pkgs.python310Packages.dataclasses-json;
    numpy = pkgs.python310Packages.numpy;
    pydantic = pkgs.python310Packages.pydantic;
    sqlalchemy = pkgs.python310Packages.sqlalchemy;
    pyyaml = pkgs.python310Packages.pyyaml;
    aiohttp = pkgs.python310Packages.aiohttp;
    requests = pkgs.python310Packages.requests;
    poetry-core = pkgs.python310Packages.poetry-core;
    setuptools = pkgs.python310Packages.setuptools;
    openai = pkgs.python310Packages.openai;
    frozenlist = pkgs.python310Packages.frozenlist;
   };
in
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

  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      vim-airline
      vim-nix
      nerdtree
      tokyonight-nvim
    ] ++ [langchainPlugin];
    extraConfig = ''
      set mouse=a
    '';
    withPython3 = true;
    extraPython3Packages = ps: [langchain ];
  };

  programs.git = {
    aliases = {
      lg = "lg1";
      lg1 = "lg1-specific --all";
      lg2 = "lg2-specific --all";
      lg3 = "lg3-specific --all";

      lg1-specific = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)'";
      lg2-specific = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(auto)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'";
      lg3-specific = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset) %C(bold cyan)(committed: %cD)%C(reset) %C(auto)%d%C(reset)%n''          %C(white)%s%C(reset)%n''          %C(dim white)- %an <%ae> %C(reset) %C(dim white)(committer: %cn <%ce>)%C(reset)'";
    };
  };

  home.packages = with pkgs; [
    supabase-cli
    # neofetch
    vscode
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
