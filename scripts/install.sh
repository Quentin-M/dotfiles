#!/bin/bash -ex

# Install nix
curl -sSf -L https://install.determinate.systems/nix | sh -s -- install --determinate
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# Darwin
if [[ $OSTYPE == 'darwin'* ]]; then
  sudo rm /etc/nix/nix.conf
  sudo mv /etc/zshenv /etc/zshenv.before-nix
  sudo nix --extra-experimental-features "nix-command flakes" run nix-darwin -- switch --flake .

# Linux
else 
  # Install home manager
  if ! type "home-manager" &> /dev/null; then
    # mkdir -p ~/.local/state/nix/profiles
    nix run home-manager/master -- init --switch
  fi
  home-manager switch --flake ~/.config/nixpkgs
fi

# Initialize zsh
zsh --login -c "              \
  echo 'Installing zimfw...'  \
  . /etc/zshrc;               \
  . ~/.zshenv;                \
  . ~/.config/zsh/.zshrc;     \
                              \
  zimfw install               \
                              \
  fast-theme free;            \
                              \
  echo 'Building fzf-tab...'; \
  build-fzf-tab-module;       \
"
