{ inputs }:
{ system, user, home ? "/Users/${user}" }:

let
  # Nixpkgs Overlays
  pkgs = import inputs.nixpkgs {
    inherit system;
    overlays = [ inputs.nurpkgs.overlay ];
    config.allowUnfree = true;
  };

in inputs.nixdarwin.lib.darwinSystem {
  inherit system;
  specialArgs = { inherit inputs user; };

  modules = [
    # Nix-darwin configuration
    ../src/darwin.nix
    
    # Home-manager configuration
    inputs.homemanager.darwinModules.home-manager {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.${user} = import ../src/home.nix;
      };
      users.users."${user}".home = home; # https://github.com/nix-community/home-manager/issues/4026
    }
  ];
}