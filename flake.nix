{
  inputs = {
    nurpkgs = {
      url = "github:nix-community/NUR";
    };
      nixpkgs = {
      url = "github:NixOS/nixpkgs?ref=release-25.05";
    };
    nixdarwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    homemanager = {
      url = "github:nix-community/home-manager?ref=release-25.05";
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
        "Quentins-MacBook-Air" = mkDarwin { user = "mentalow"; system = "aarch64-darwin"; };
        "Quentins-MacBook-Air-BitMEX" = mkDarwin { user = "quentin.machu-ext"; system = "aarch64-darwin"; isPro = true; };
        "Quentins-Laptop" = mkDarwin { user = "qmachu"; system = "aarch64-darwin"; isPro = true; };
      };
      homeConfigurations = {
        "vagrant" = mkHomeManager { user = "vagrant"; system = "aarch64-linux"; home = "/home/vagrant"; };
        "mentalow" = mkHomeManager { user = "mentalow"; system = "x86_64-linux"; home = "/home/mentalow"; };
      };
    };
}
