{ isPro ? false }:

let
    common = [
        "brave-browser"
        "iterm2"
        "microsoft-onenote"
        "tailscale"
        "cleanshot"
        "chatgpt"
        "orbstack"
        "visual-studio-code"
        "postico"
        "tableplus"
        #"1password" (can't launch - was outdated)
        "1password-cli"
        "raycast"
        "monodraw"
        "bruno"
        "jordanbaird-ice"
        "loop"
        "stats"
        "keka"
        "vlc"
        "grandperspective"
    ];

    home = [
      "discord"
      "anydesk"
      "eddie"
      "hashicorp/tap/hashicorp-vagrant"
      "virtualbox"
    ];

    pro = [
      "slack"
    ];

in common ++ (if isPro then pro else home)