{
  description = "NixOS flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations.yeoz-nano = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs system;
        usingOfficialRaspiImg = false;
      };
      modules = [
        ./hosts/yeoz-nano/system

        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.saya = import ./hosts/yeoz-nano/user;
          home-manager.extraSpecialArgs = {
            inherit inputs;
            pkgs-unfree = import inputs.nixpkgs { inherit system; config.allowUnfree = true; };
            isLabtop = true;
          };
        }

        inputs.nix-index-database.nixosModules.nix-index
        { programs.nix-index-database.comma.enable = true; }
      ];
    };
    nixosConfigurations.yeoz-zen = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = { 
        inherit inputs system;
        usingOfficialRaspiImg = false;
      };
      modules = [
        ./hosts/yeoz-zen/system

        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.saya = import ./hosts/yeoz-zen/user;
          home-manager.extraSpecialArgs = {
            inherit inputs;
            pkgs-unfree = import inputs.nixpkgs { inherit system; config.allowUnfree = true; };
            isLabtop = true;
          };
        }

        inputs.nix-index-database.nixosModules.nix-index
        { programs.nix-index-database.comma.enable = true; }
      ];
    };
    nixosConfigurations.yeoz-pi = nixpkgs.lib.nixosSystem rec {
      system = "aarch64-linux";
      specialArgs = {
        inherit inputs system;
        usingOfficialRaspiImg = true;
      };
      modules = [
        ./hosts/yeoz-pi/system
        
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.saya = import ./hosts/yeoz-pi/user;
          home-manager.extraSpecialArgs = {
            inherit inputs;
            pkgs-unfree = import inputs.nixpkgs { inherit system; config.allowUnfree = true; };
            isLabtop = false;
          };
        }

        inputs.nix-index-database.nixosModules.nix-index
        { programs.nix-index-database.comma.enable = true; }
      ];
    };
  };
}
