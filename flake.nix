{
  description = "Luc's nix configuration";

  inputs = {
    ## Package sets
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    unstable.follows = "nixpkgs";

    #TODO: get this working
    ## Allows gdb to look up debug info
    dwarffs.url = "github:edolstra/dwarffs";

    nixpkgs-wayland  = {
      url = "github:nix-community/nixpkgs-wayland";
    };

    ## home-manager pins nixpkgs to a specific version in its flake.
    ## we want to make sure everything pins to the same version of nixpkgs to be more efficient
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ## agenix allows me to store encrypted secrets in the repo just like git-crypt, except
    ## it integrates with nix so I don't need to have world-readable secrets in the nix store.
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #TODO: separate each config into its own flake to avoid pulling unnecessary deps? or is nix smart enough
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{self, nixpkgs, home-manager, agenix, nixos-generators, darwin, dwarffs, ...}:
    let
    user = "luc";

    pkgs = import nixpkgs {
      config.allowUnfree = true;
    };

    localNixpkgsOverlay = self: super: {
      nixpkgs = super.callPackage ../nixpkgs { };
    };
  in {

    darwinConfigurations = {
      air = let
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          overlays = [ localNixpkgsOverlay ];
        };
      in inputs.darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          home-manager.darwinModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.luc = import ./home-manager/luc-macos.nix;
          }
          # agenix.nixosModules
          ./hosts/air/host.nix
          #./config/cli-darwin.nix
        ];
      };
    };

    ## Cloud server configs
    ## Let's fucking go!!!
    lfg = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };
      modules = [
        ./home-manager/lfg.nix
        {
          home = {
            username = "ubuntu";
            homeDirectory = "/home/ubuntu";
          };
        }
      ];
    };

    packages.x86_64-linux = {
      vm = nixos-generators.nixosGenerate {
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
            ./hosts/vm/host.nix

            # Device is a personal laptop
            #./config/vm.nix
            ./config/personal.nix
            ./config/cli.nix

            ## Give access to network filestore
            #./config/file_access.nix

            ## Use X11 Gnome
            #./config/desktop_env/gnome_xorg.nix
            #./config/desktop_env/oled_gnome.nix

            # Use Wayland Gnome
            ./config/desktop_env/gnome.nix
            # ./config/desktop_env/gnome_material_shell.nix

            ## Use Wayland Sway
            #./config/desktop_env/sway.nix

            # Use pipewire
            ./module/audio.nix
            # ./module/audio_bt.nix
          ];
          format = "vm";
      };
      vbox = nixos-generators.nixosGenerate {
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
            ./hosts/vm/host.nix

            # Device is a personal laptop
            #./config/vm.nix
            ./config/personal.nix
            ./config/cli.nix

            ## Give access to network filestore
            #./config/file_access.nix

            ## Use X11 Gnome
            #./config/desktop_env/gnome_xorg.nix
            #./config/desktop_env/oled_gnome.nix

            # Use Wayland Gnome
            ./config/desktop_env/gnome.nix
            # ./config/desktop_env/gnome_material_shell.nix

            ## Use Wayland Sway
            #./config/desktop_env/sway.nix

            # Use pipewire
            ./module/audio.nix
            # ./module/audio_bt.nix
          ];
        format = "virtualbox";
      };
    };

    nixosConfigurations = {
      linux-vm = inputs.nixpkgs.lib.nixosSystem {
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
            <nixpkgs/nixos/modules/virtualisation/qemu-vm.nix>
            # Hardware configuration
            ./hosts/vm/host.nix

            # Device is a personal laptop
            ./config/vm.nix
            ./config/personal.nix
            ./config/cli.nix

            ## Give access to network filestore
            #./config/file_access.nix

            ## Use X11 Gnome
            #./config/desktop_env/gnome_xorg.nix
            #./config/desktop_env/oled_gnome.nix

            # Use Wayland Gnome
            ./config/desktop_env/gnome.nix
            # ./config/desktop_env/gnome_material_shell.nix

            ## Use Wayland Sway
            #./config/desktop_env/sway.nix

            # Use pipewire
            ./module/audio.nix
            # ./module/audio_bt.nix
        ];
        specialArgs = { inherit inputs; };
      };

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

          ## Use Wayland Sway
          #./config/desktop_env/sway.nix

          # Use pipewire
          ./module/audio.nix
          # ./module/audio_bt.nix
        ];
        specialArgs = { inherit inputs; };
      };

      frieza = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          dwarffs.nixosModules.dwarffs
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
          ./config/weylus.nix

          # Device is a personal laptop
          ./config/base-desktop.nix
          ./config/personal.nix
          ./config/cli.nix
          ./config/dev.nix

          # Device is ssh server
          ./config/ssh-server.nix

          # Device is dev machine
          ./config/docker.nix

          ## Give access to network filestore
          #./config/file_access.nix

          ## Use X11 Gnome
          #./config/desktop_env/gnome_xorg.nix
          #./config/desktop_env/oled_gnome.nix

          # Use Wayland Gnome
          ./config/desktop_env/gnome.nix

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
