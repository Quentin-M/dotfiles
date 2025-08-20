{ isPro ? false }:

let
    common = [];

    home = [
      "hashicorp/tap"
    ];

    pro = [
      "didhd/tap" # amazon-bedrock-client
    ];

in common ++ (if isPro then pro else home)
