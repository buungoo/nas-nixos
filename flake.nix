{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable"; # Use latest unstable
    home-manager.url = "github:nix-community/home-manager/master"; # Use latest unstable
    home-manager.inputs.nixpkgs.follows = "nixpkgs"; # Tell home-manager which nixpkgs version it should use
  };

  outputs = { self, nixpkgs, home-manager, ... }:
  let lib = nixpkgs.lib; system = "x86_64-linux"; in {
    nixosConfigurations."nas0" = lib.nixosSystem {
      inherit system;
      modules = [ ./configuration.nix ];
    };

    homeConfigurations."bungo" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      modules = [ ./home.nix ];
    };
  };
}
