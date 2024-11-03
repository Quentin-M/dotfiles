#
# All nix-darwin options: https://mynixos.com/nix-darwin/options/system.defaults
#
{
  pkgs,
  user,
  ...
}: {
  # Nix Daemon & Nix auto-update.
  system.stateVersion = 4;

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
    brews = [
      "mas" # let nix install mac app store apps
      "pam-reattach" # used to enable pam touchid in tmux
      "ykman" # yubikey tool
      "aws-shell"
      ## bitmex ##
      "git"
      "step"
      "kubelogin"
      # (api build deps)
      "pkg-config"
      "cairo"
      "pango"
      "libpng"
      "jpeg"
      "giflib"
      "librsvg"
      "pixman"
    ];

    casks = [
      "brave-browser"
      "iterm2"
      "microsoft-onenote"
      "tailscale"
      "anydesk"
      "cleanshot"

      "zoom"
      "slack"
      "discord"
      "chatgpt"

      "orbstack"
      "visual-studio-code"
      "postico"
      "tableplus"

      #"1password" (was outdated)
      "1password-cli"

      "raycast"
      "monodraw"
      "insomnia"

      "jordanbaird-ice"
      "loop"
      "stats"

      "eddie"
      "keka"
      "vlc"
      "grandperspective"
      "hashicorp/tap/hashicorp-vagrant"
      "virtualbox"
    ];

    masApps = {};
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
      showhidden = true;
      show-recents = true;
      persistent-apps = [
        "/Applications/Brave Browser.app"
        "/System/Applications/Mail.app"
        "/Applications/Slack.app"
        "/Applications/ChatGPT.app"
        "/Applications/Microsoft OneNote.app"
        "/Applications/Visual Studio Code.app"
        "/Applications/iTerm.app"
        "/Applications/Monodraw.app"
        "/Applications/Raycast.app"
        "/Applications/Insomnia.app"
      ];
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
  security.pam.enableSudoTouchIdAuth = true;

  # While already set in home.nix, this line instructs nix-darwin
  # to configure the /etc/zshenv file to load the environment.
  programs.zsh.enable = true;
}
