{
  inputs = {
    nurpkgs = {
      url = "github:nix-community/NUR";
    };
      nixpkgs = {
      url = "github:NixOS/nixpkgs?ref=release-24.05";
    };
    nixdarwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    homemanager = {
      url = "github:nix-community/home-manager?ref=release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, nixdarwin, homemanager, nurpkgs }: let
    # Make functions
    mkHomeManager = import ./lib/mkHome.nix { inherit inputs; };
    mkDarwin = import ./lib/mkDarwin.nix { inherit inputs; };

    # Outputs
    in {
      darwinConfigurations = {
        "Quentins-MacBook-Pro" = mkDarwin { user = "quentinmachu"; system = "aarch64-darwin"; isPro = true; };
        "Quentins-MacBook-Air" = mkDarwin { user = "mentalow"; system = "aarch64-darwin"; };
      };
      homeConfigurations = {
        "vagrant" = mkHomeManager { user = "vagrant"; system = "aarch64-linux"; home = "/home/vagrant"; };
        "mentalow" = mkHomeManager { user = "mentalow"; system = "x86_64-linux"; home = "/home/mentalow"; };
      };
    };
}