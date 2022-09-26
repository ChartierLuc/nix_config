{
description = "Luc's nix configuration";

inputs = {
  nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
  unstable.follows = "nixpkgs";
  
  nixpkgs-wayland  = {
    url = "github:nix-community/nixpkgs-wayland"; 
    };

  # # home-manager pins nixpkgs to a specific version in its flake.
  # # we want to make sure everything pins to the same version of nixpkgs to be more efficient
  home-manager = {
    url = github:nix-community/home-manager;
    inputs.nixpkgs.follows = "nixpkgs";
    };

  # # agenix allows me to store encrypted secrets in the repo just like git-crypt, except
  # # it integrates with nix so I don't need to have world-readable secrets in the nix store.
  # agenix = {
  #             url = "github:ryantm/agenix";
  #             inputs.nixpkgs.follows = "nixpkgs";
  #           };

  #TODO: separate each config into its own flake to avoid pulling unnecessary deps? or is nix smart enough
  nixos-wsl = {
    url = "github:nix-community/NixOS-WSL";
    inputs.nixpkgs.follows = "nixpkgs";
    };
  };

outputs = inputs@{self, nixpkgs, home-manager,  ...}:

let
  user = "luc";
  system = "x86_64-linux";
  
  pkgs = import nixpkgs {
    config.allowUnfree = true;
    # # TODO: Look at overlays
    # overlays = [
    #             ];
  };

in {
  # TODO: Look at overlays
  inputs.nixpkgs.overlays = [
    #import ./overlays/default.nix
  ]; 
  nixosConfigurations = { 
    miBook = inputs.nixpkgs.lib.nixosSystem { 
      system = "x86_64-linux";
      modules = [
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true; # instead of having its own private nixpkgs
          home-manager.useUserPackages = true; # install to /etc/profiles instead of ~/.nix-profile
          home-manager.extraSpecialArgs = {
            inherit user; # pass user to modules in conf (home.nix or whatever)
            configName = "miBook";
          };
          home-manager.users.luc = import ./home-manager/luc.nix;
        }
        # Hardware configuration
        ./hosts/miBook/host.nix

        # Device is a personal laptop
        ./config/base-desktop.nix
        ./config/personal.nix
        ./config/cli.nix
      
        ## Give access to network filestore
        #./config/file_access.nix
    
        ## Use X11 Gnome
        #./config/desktop_env/gnome_xorg.nix
        #./config/desktop_env/oled_gnome.nix

        # Use Wayland Gnome
        ./config/desktop_env/gnome.nix
        ./config/desktop_env/gnome_material_shell.nix
      
        ## Use Wayland Sway
        #./config/desktop_env/sway.nix

        # Use pipewire
        ./module/audio.nix
        ./module/audio_bt.nix
      ];
      specialArgs = { inherit inputs; };
    };

    frieza = inputs.nixpkgs.lib.nixosSystem { 
      system = "x86_64-linux";
      modules = [
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true; # instead of having its own private nixpkgs
          home-manager.useUserPackages = true; # install to /etc/profiles instead of ~/.nix-profile
          home-manager.extraSpecialArgs = {
            inherit user; # pass user to modules in conf (home.nix or whatever)
            configName = "frieza";
          };
          home-manager.users.luc = import ./home-manager/luc.nix;
        }
        # Hardware configuration
        ./hosts/frieza/host.nix

        # Device is a personal laptop
        ./config/base-desktop.nix
        ./config/personal.nix
        ./config/cli.nix
      
        ## Give access to network filestore
        #./config/file_access.nix
    
        ## Use X11 Gnome
        #./config/desktop_env/gnome_xorg.nix
        #./config/desktop_env/oled_gnome.nix

        # Use Wayland Gnome
        ./config/desktop_env/gnome.nix
        ./config/desktop_env/gnome_material_shell.nix
      
        ## Use Wayland Sway
        #./config/desktop_env/sway.nix

        # Use pipewire
        ./module/audio.nix
      ];
      specialArgs = { inherit inputs; };
    };

    G7 = inputs.nixpkgs.lib.nixosSystem { 
      system = "x86_64-linux";
      modules = [
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true; # instead of having its own private nixpkgs
          home-manager.useUserPackages = true; # install to /etc/profiles instead of ~/.nix-profile
          home-manager.extraSpecialArgs = {
            inherit user; # pass user to modules in conf (home.nix or whatever)
            configName = "G7";
          };
          home-manager.users.luc = import ./home-manager/luc.nix;
        }
        # Hardware configuration
        ./hosts/G7/host.nix
        ./config/common.nix

        # Device is a personal laptop
        ./config/base-desktop.nix
        ./config/personal.nix
        ./config/cli.nix
    
        ## Give access to network filestore
        #./config/file_access.nix
  
        # Use X11 Gnome
        ./config/desktop_env/xorg.nix
        ./config/desktop_env/oled_gnome.nix

        ## Use Wayland Wayfire
        #./module/wayfire.nix

        # Use pipewire
        ./module/audio.nix
      ];
      specialArgs = { inherit inputs; };
    };
  };
};
}
