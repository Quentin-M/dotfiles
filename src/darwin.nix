#
# All nix-darwin options: https://mynixos.com/nix-darwin/options/system.defaults
#
{
  pkgs,
  user,
  isPro,
  ...
}: {
  # Nix Daemon & Nix auto-update.
  nix.enable = false; # we use Determinate instead of nix-darwin's management
  system = {
    stateVersion = 4;
    primaryUser = user;
  };
  nix = {
    settings = {
      trusted-users = ["root" "nixbld" user];

      extra-trusted-substituters = [
        "https://cache.flakehub.com"
        "https://devenv.cachix.org"
      ];
      extra-trusted-public-keys = [
        "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM= cache.flakehub.com-4:Asi8qIv291s0aYLyH6IOnr5Kf6+OF14WVjkE6t3xMio= cache.flakehub.com-5:zB96CRlL7tiPtzA9/WKyPkp3A2vqxqgdgyTVNGShPDU= cache.flakehub.com-6:W4EGFwAGgBj3he7c5fNh9NkOXw0PUVaxygCVKeuvaqU= cache.flakehub.com-7:mvxJ2DZVHn/kRxlIaxYNMuDG1OvMckZu32um1TadOR8= cache.flakehub.com-8:moO+OVS0mnTjBTcOUh2kYLQEd59ExzyoW1QgQ8XAARQ= cache.flakehub.com-9:wChaSeTI6TeCuV/Sg2513ZIM9i0qJaYsF+lZCXg0J6o= cache.flakehub.com-10:2GqeNlIp6AKp4EF2MVbE1kBOp9iBSyo0UPR9KoR0o1Y="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      ];
    };

    optimise.automatic = true;
    gc.automatic = true;
    
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Fonts
  fonts.packages = with pkgs; [meslo-lgs-nf];

  # System packages.
  environment.systemPackages = with pkgs; [
    pinentry_mac # yubikey PIN UI
    yubikey-personalization # yubikey tool
  ];

  # Homebrew
  homebrew = {
    enable = true;
    taps = import ../conf/pkgs/taps.nix { inherit isPro; };
    brews = import ../conf/pkgs/brews.nix { inherit isPro; };
    casks = import ../conf/pkgs/casks.nix { inherit isPro; };
    masApps = import ../conf/pkgs/mas.nix { inherit isPro; };

    onActivation.cleanup = "zap";
    global.autoUpdate = false;
  };

  # Darwin fun
  system.defaults = {
    # Dock
    dock = {
      autohide = true;
      mru-spaces = false;
      orientation = "bottom";
      showhidden = false;
      show-recents = true;
      persistent-apps = import ../conf/pkgs/dock.nix { inherit isPro; };
      # fan display / sorting: https://github.com/nix-darwin/nix-darwin/issues/982
      persistent-others = [
        "/Users/${user}/Downloads/"
      ];
    };

    # Finder
    finder = {
      AppleShowAllFiles = true;
      AppleShowAllExtensions = true;
      QuitMenuItem = true;
      CreateDesktop = false;
      ShowPathbar = true;
      ShowStatusBar = true;
      FXPreferredViewStyle = "Nlsv";
      FXEnableExtensionChangeWarning = false;
    };

    # Trackpad
    trackpad = {
      Clicking = true;
      TrackpadRightClick = true;
      TrackpadThreeFingerDrag = true;
    };
    NSGlobalDomain."com.apple.swipescrolldirection" = false;

    # Hide date/time - we use Stats' date/time instead
    menuExtraClock = {
      IsAnalog = true;
      ShowDate = 2;
    };
  };

  # Add ability to used TouchID for sudo authentication
  # Requires the pam_reattach brew package for tmux
  security.pam.services.sudo_local.touchIdAuth = true;

  # While already set in home.nix, this line instructs nix-darwin
  # to configure the /etc/zshenv file to load the environment.
  programs.zsh.enable = true;
}
