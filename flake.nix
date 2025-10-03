{
  description = "NixOS flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    daeuniverse.url = "github:daeuniverse/flake.nix";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix4nvchad = {
      url = "github:nix-community/nix4nvchad";
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
      };
      modules = [
        ./hardware-configuration.nix
        ./hosts/yeoz-nano/system

        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.saya = import ./hosts/yeoz-nano/user;
          home-manager.extraSpecialArgs = {
            inherit inputs;
            pkgs-unfree = import inputs.nixpkgs { inherit system; config.allowUnfree = true; };
          };
        }

        inputs.daeuniverse.nixosModules.dae
        inputs.daeuniverse.nixosModules.daed
        inputs.nix-index-database.nixosModules.nix-index
        { programs.nix-index-database.comma.enable = true; }
      ];
    };
    nixosConfigurations.yeoz-zen = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = { inherit inputs system; };
      modules = [
        ./hardware-configuration.nix
        ./hosts/yeoz-zen/system

        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.saya = import ./hosts/yeoz-zen/user;
          home-manager.extraSpecialArgs = {
            inherit inputs;
            pkgs-unfree = import inputs.nixpkgs { inherit system; config.allowUnfree = true; };
          };
        }

        inputs.nix-index-database.nixosModules.nix-index
        { programs.nix-index-database.comma.enable = true; }
        inputs.daeuniverse.nixosModules.dae
        inputs.daeuniverse.nixosModules.daed
      ];
    };
    nixosConfigurations.yeoz-pi = nixpkgs.lib.nixosSystem rec {
      system = "aarch64-linux";
      specialArgs = { inherit inputs system; };
      modules = [
        ./hardware-configuration.nix
        ./hosts/yeoz-pi/system

        
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.saya = import ./hosts/yeoz-pi/user;
          home-manager.extraSpecialArgs = {
            inherit inputs;
            pkgs-unfree = import inputs.nixpkgs { inherit system; config.allowUnfree = true; };
          };
        }

        inputs.nix-index-database.nixosModules.nix-index
        { programs.nix-index-database.comma.enable = true; }
        inputs.daeuniverse.nixosModules.dae
        inputs.daeuniverse.nixosModules.daed
      ];
    };
  };
}
