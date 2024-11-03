{ inputs }:
{ system, user, home ? "/home/${user}" }:

let
  # Nixpkgs Overlays
  pkgs = import inputs.nixpkgs {
    inherit system;
    overlays = [ inputs.nurpkgs.overlay ];
    config.allowUnfree = true;
  };

in inputs.homemanager.lib.homeManagerConfiguration {
  inherit pkgs;

  modules = [
    ../src/home.nix
    {
      home = {
        stateVersion = "24.05";
        username = user;
        homeDirectory = "${home}";
      };
    }
  ];
}