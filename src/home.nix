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
    # zsh/starship/zim requirements
    starship
    pandoc
    mdcat
    bat
    bat-extras.batman
    bat-extras.batgrep
    bat-extras.batdiff
    bat-extras.batwatch
    bat-extras.prettybat
    fzf
    delta
    choose
    tree-sitter
    zoxide
    grc

    # nvim requirements
    nixd
    alejandra
    deadnix
    statix

    # we like gnu tools
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

    # shell utilities
    tldr
    eza
    fd
    ripgrep
    dogdns
    thefuck
    git

    awscli2
    mise
    kubectl
    kubectx
    #devenv
    direnv
    mtr
    ipcalc
    ipmitool
    htop
    jq
    pgcli
    weechat

    # nvim's nix package
    nixd
    alejandra
    deadnix
    statix
    tree-sitter
  ];

  packagesNodes = with pkgs.nodePackages; [];

  packagesPython = with pkgs.python313Packages; [
    pip
  ];
in
  with pkgs; {
    # Home-manager
    programs.home-manager.enable = true;
    home = {
      stateVersion = "25.05";
      packages = packages ++ packagesNodes ++ packagesPython;
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
      enableCompletion = false;
      initContent = builtins.readFile ../conf/zsh/zshrc;
    };
    xdg.configFile."zsh/.zimrc".source = ../conf/zsh/zimrc;
    xdg.configFile."starship.toml".source = ../conf/zsh/starship.toml;
    home.file.".hushlogin".text = "";

    # Tmux
    programs.tmux = {
      enable = true;
      extraConfig = builtins.readFile ../conf/zsh/tmux.conf;
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
          merge = {conflictstyle = "zdiff3";};
          push = {default = "current";};
          pull = {rebase = true;};
          rebase = {"autosquash" = true;};
        }
        // import ../conf/git/config;
      aliases = {
        fix = "!git log -n 50 --pretty=format:'%h %s' --no-merges | fzf | choose 0 | xargs -o git commit --fixup";
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
