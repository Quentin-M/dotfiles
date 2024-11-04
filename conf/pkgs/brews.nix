{ isPro ? false }:

let
    common = [
        "mas"          # let nix install mac app store apps
        "pam-reattach" # used to enable pam touchid in tmux
        
        "aws-shell"
        "ykman"
    ];

    home = [];

    pro = [
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

in common ++ (if isPro then pro else home)