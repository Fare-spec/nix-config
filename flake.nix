{
  description = "My nixos conf.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs"; # Makes it follow the nixpkgs channel so avoid another revision pull
    };
    nixpkgs-kernel.url = "github:NixOS/nixpkgs/e103cdf5df7e47c1a47ebe410196c9ec1fff351c";

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      ...
    }:
    {
      nixosConfigurations.framework = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = {
          inherit inputs;
        };

        modules = [
          ./hosts/framework

          home-manager.nixosModules.home-manager
          inputs.lanzaboote.nixosModules.lanzaboote

          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "hm-backup";

            home-manager.extraSpecialArgs = {
              inherit inputs;
            };

            home-manager.users.spectre = ./home/spectre;
          }
        ];
      };
    };
}
