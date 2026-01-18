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
          hostName,
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
              hostName
              ;
          };
          modules = [
            ./hosts/${hostName}/system

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.saya =
                { ... }:
                {
                  imports = [
                    ./hosts/${hostName}/user
                  ];
                };
              home-manager.extraSpecialArgs = {
                inherit inputs self hostName;
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
            ./secrets
            {
              networking.hostName = hostName;
              programs.nix-index-database.comma.enable = true;
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        suzu = mkSystem {
          hostName = "suzu";
          system = "x86_64-linux";
          bootMode = "systemd-boot";
        };
        gohei = mkSystem {
          hostName = "gohei";
          system = "x86_64-linux";
          bootMode = "systemd-boot";
        };
        omamori = mkSystem {
          hostName = "omamori";
          system = "aarch64-linux";
          bootMode = "systemd-boot";
        };
        ofuda = mkSystem {
          hostName = "ofuda";
          system = "x86_64-linux";
          bootMode = "grub-bios";
          bootDevice = "/dev/vda";
        };
        sakaki = mkSystem {
          hostName = "sakaki";
          system = "x86_64-linux";
          bootMode = "systemd-boot";
        };
      };
    };
}
