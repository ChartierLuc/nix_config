{
  description = "Luc's nix configuration";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    unstable.follows = "nixpkgs";

    utils.url = github:gytis-ivaskevicius/flake-utils-plus;
    devshell.url = github:numtide/devshell;
    devshell.inputs.nixpkgs.follows = "nixpkgs";
    devshell.inputs.flake-utils.follows = "utils";

    nix2vim.url = github:gytis-ivaskevicius/nix2vim;
    nix2vim.inputs.nixpkgs.follows = "nixpkgs";
    nix2vim.inputs.flake-utils.follows = "utils";

    # home-manager pins nixpkgs to a specific version in its flake.
    # we want to make sure everything pins to the same version of nixpkgs to be more efficient
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # agenix allows me to store encrypted secrets in the repo just like git-crypt, except
    # it integrates with nix so I don't need to have world-readable secrets in the nix store.
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO: separate each config into its own flake to avoid pulling unnecessary deps? or is nix smart enough
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix2vim, utils, home-manager, ... }:
    let
      pkgs = self.pkgs.x86_64-linux.nixpkgs;
      mkApp = utils.lib.mkApp;
      suites = import ./suites.nix { inherit utils: }:
    in
    with suites.nixosModules;
    utils.lib.mkFlake {
      inherit self inputs;
      inherit (suites) nixosModules;

      supportedSystems = [ "aarch64-linux" "x86_64-linux" ];
      channelsConfig.allowUnfree = true;

      channels.nixpkgs.overlaysBuilder = channels: [
        (final: prev: {
          #inherit (channels.unstable) pure-prompt neovim-unwrapped linuxPackages_latest gcc11Stdenv layan-gtk-theme;
        })
      ];

      hosts.G7.modules = suites.desktopModules ++ [
        {
          security.apparmor.enable = true;
        }

        ./hosts/G7.host.nix
      ];

      sharedOverlays = [
        self.overlay
        nix2vim.overlay
        (final: prev: {
          firefox = prev.riced-firefox;
        })
      ];

      hostDefaults.modules = [
        home-manager.nixosModules.home-manager
      ] ++ suites.sharedModules;

      outputsBuilder = channels: with channels.nixpkgs;{
        defaultPackage = riced-neovim;

        packages = {
          inherit
            riced-alacritty
            riced-firefox
            riced-neovim
            ;
        };

        devshell = mkShell {
          buildInputs = [ git ];
        };
      };

      overlay = import ./overlays;

    };
}