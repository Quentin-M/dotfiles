#
# configuration options: https://mynixos.com/home-manager/options
#
{
  pkgs,
  user,
  config,
  ...
}: let
  packages = with pkgs; [
    coreutils # sha256sum, base64, etc
    moreutils # sponge, parallel
    gawk
    gnugrep
    gnumake
    gnused
    gnutar
    curl
    openssl
    unixtools.watch
    autoconf
    automake
    cmake
    wget

    navi
    tldr
    eza
    fd
    fzf
    ripgrep
    bat
    bat-extras.batman
    bat-extras.batgrep
    bat-extras.batdiff
    bat-extras.batwatch
    bat-extras.prettybat
    dogdns
    thefuck
    tree-sitter
    zoxide

    git
    git-crypt
    delta
    awscli2
    asdf-vm
    kubectl
    kubectx

    mtr
    ipcalc
    ipmitool
    htop
    lnav
    jq
    pgcli
    weechat

    # nvim's nix package
    nixd
    alejandra
    deadnix
    statix
  ];

  packagesNodes = with pkgs.nodePackages; [];

  packagesGit = with pkgs.gitAndTools; [
    delta
  ];

  packagesPython = with pkgs.python310Packages; [
    pip
    requests
  ];
in
  with pkgs; {
    # Home-manager
    programs.home-manager.enable = true;
    home = {
      stateVersion = "24.05";
      packages = packages ++ packagesNodes ++ packagesGit ++ packagesPython;
    };

    # Nix-index
    programs.nix-index.enable = true;

    # ZSH
    programs.zsh = {
      enable = true;
      dotDir = ".config/zsh";
      envExtra = ''
        export ZSH_CACHE_DIR=~/.cache
        export LANG=en_US.UTF-8
      '';
      initExtra = builtins.readFile ../conf/zsh/zshrc;
    };
    xdg.configFile."zsh/.zimrc".source = ../conf/zsh/zimrc;
    xdg.configFile."zsh/.p10k.zsh".source = ../conf/zsh/p10k.zsh;

    # Tmux
    programs.tmux = {
      enable = true;
      extraConfig = builtins.readFile ../conf/tmux.conf;
    };
    home.file.".tmux/plugins/tpm" = {
      source = builtins.fetchGit {
        url = "https://github.com/tmux-plugins/tpm";
        rev = "99469c4a9b1ccf77fade25842dc7bafbc8ce9946";
      };
    };

    # Git
    programs.git = {
      enable = true;
      extraConfig =
        {
          core = {
            pager = "delta";
            sshCommand = "ssh";
          };
          interactive = {diffFilter = "delta --color-only";};
          delta = {
            navigate = true;
            side-by-side = true;
            syntax-theme = true;
          };
          merge = {conflictstyle = "diff3";};
          push = {default = "current";};
          pull = {rebase = true;};
          rebase = {"autosquash" = true;};
        }
        // import ../conf/git/config;
      aliases = {
        fix = "!git log -n 50 --pretty=format:'%h %s' --no-merges | fzf | xargs -o git commit --fixup";
      };
      ignores = lib.splitString "\n" (builtins.readFile ../conf/git/ignore);
    };

    # SSH
    programs.ssh = {
      enable = true;
      controlMaster = "auto";
      controlPersist = "2m";
      addKeysToAgent = "yes";
      forwardAgent = true;
      compression = true;
      matchBlocks = {
        "*.bitmex.vpn *.bitmex.ad" = {
          user = "qmachu";
          extraOptions = {
            Include = "~/.step/ssh/includes";
          };
        };
        "*" = {
          extraOptions = {
            IdentityAgent = "\"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"";
          };
        };
      };
    };

    # AstroNvim
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
    };
    home.file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixpkgs/conf/nvim";

    # Weechat
    home.file.".config/weechat".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixpkgs/conf/weechat";
  }
