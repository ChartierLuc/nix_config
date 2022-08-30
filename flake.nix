{
  description = "Luc's nix configuration";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    unstable.follows = "nixpkgs";

    # # home-majnager pins nixpkgs to a specific version in its flake.
    # # we want to make sure everything pins to the same version of nixpkgs to be more efficient
    # home-manager = {
    #   url = github:nix-community/home-manager;
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # # agenix allows me to store encrypted secrets in the repo just like git-crypt, except
    # # it integrates with nix so I don't need to have world-readable secrets in the nix store.
    # agenix = {
    #   url = "github:ryantm/agenix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # # TODO: separate each config into its own flake to avoid pulling unnecessary deps? or is nix smart enough
    # nixos-wsl = {
    #   url = "github:nix-community/NixOS-WSL";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

  };

  outputs = inputs:
    {
      nixosConfigurations = {
        miBook = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/miBook/host.nix
            ./config/base-desktop.nix
            ./config/personal.nix
            ./config/xorg.nix
            ./config/cli.nix
            ./config/oled.nix
          ];
          specialArgs = { inherit inputs; };
        };
      };
    };
}