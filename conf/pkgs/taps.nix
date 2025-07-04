{ isPro ? false }:

let
    common = [];

    home = [
      "hashicorp/tap"
    ];

    pro = [];

in common ++ (if isPro then pro else home)
