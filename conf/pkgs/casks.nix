{ isPro ? false }:

let
    common = [
        "brave-browser"
        "iterm2"
        "tailscale-app"
        "cleanshot"
        "claude-code"
        "orbstack"
        "visual-studio-code"
        "postico"
        "tableplus"
        "1password"
        "1password-cli"
        "raycast"
        "monodraw"
        "bruno"
        "jordanbaird-ice"
        "loop"
        "stats"
        "keka"
        "iina"
        "grandperspective"
        "obsidian"
    ];

    home = [
      "discord"
      "anydesk"
      "eddie"
      "netnewswire"
      "hashicorp/tap/hashicorp-vagrant"
      "virtualbox"
    ];

    pro = [
      "slack"
      "amazon-bedrock-client"
      "drawio"
    ];

in common ++ (if isPro then pro else home)
