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
