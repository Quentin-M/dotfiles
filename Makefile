SHELL:=/bin/bash

install:
	./scripts/install.sh

uninstall:
	./scripts/uninstall.sh

repl:
	nix --extra-experimental-features repl-flake repl ".#darwinConfigurations.$$(hostname)"

switch:
	@if [[ $${OSTYPE} == 'darwin'* ]]; then \
		darwin-rebuild switch --flake $${HOME}/.config/nixpkgs; \
	else \
		home-manager switch --flake $${HOME}/.config/nixpkgs; \
	fi
