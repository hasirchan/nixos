{
  description = "Multi-Host NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
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

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      mkSystem =
        {
          hostname,
          system,
          bootMode,
          bootDevice ? null,
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit
              inputs
              system
              bootMode
              bootDevice
              self
              ;
          };
          modules = [
            ./hosts/${hostname}/system

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.saya =
                { ... }:
                {
                  imports = [
                    ./hosts/${hostname}/user
                  ];
                  sops.age.keyFile = "/home/saya/.config/sops/age/keys.txt";
                };
              home-manager.extraSpecialArgs = {
                inherit inputs self;
                pkgs-unfree = import nixpkgs {
                  inherit system;
                  config.allowUnfree = true;
                };
              };
              home-manager.sharedModules = [
                inputs.sops-nix.homeManagerModules.sops
              ];

            }
            inputs.sops-nix.nixosModules.sops

            inputs.nix-index-database.nixosModules.nix-index
            { programs.nix-index-database.comma.enable = true; }

            { networking.hostName = hostname; }
            ./sops-nix.nix
          ];
        };
    in
    {
      nixosConfigurations = {
        suzu = mkSystem {
          hostname = "suzu";
          system = "x86_64-linux";
          bootMode = "systmed-boot";
        };
        gohei = mkSystem {
          hostname = "gohei";
          system = "x86_64-linux";
          bootMode = "systemd-boot";
        };
        omamori = mkSystem {
          hostname = "omamori";
          system = "aarch64-linux";
          bootMode = "uboot";
        };
        ofuda = mkSystem {
          hostname = "ofuda";
          system = "x86_64-linux";
          bootMode = "grub-bios";
          bootDevice = "/dev/vda";
        };
      };
    };
}
