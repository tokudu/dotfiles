#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Install Homebrew if it's not already installed.
if ! command -v brew &> /dev/null; then
	echo "Installing Homebrew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	# Determine the Homebrew prefix path
	if [ -f /opt/homebrew/bin/brew ]; then
		BREW_BIN="/opt/homebrew/bin/brew"
	elif [ -f /usr/local/bin/brew ]; then
		BREW_BIN="/usr/local/bin/brew"
	else
		echo "Error: Homebrew installation not found." >&2
		exit 1
	fi

	# Persist Homebrew shellenv in ~/.bash_profile so future shells have it
	SHELLENV_LINE="eval \"\$(${BREW_BIN} shellenv)\""
	if ! grep -qF "$SHELLENV_LINE" ~/.bash_profile 2>/dev/null; then
		echo "" >> ~/.bash_profile
		echo "# Homebrew" >> ~/.bash_profile
		echo "$SHELLENV_LINE" >> ~/.bash_profile
	fi

	# Source it now so the rest of this script can use brew
	eval "$($BREW_BIN shellenv)"
	source ~/.bash_profile
fi

# Make sure we're using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Save Homebrew's installed location.
BREW_PREFIX=$(brew --prefix)

# Install GNU core utilities (those that come with macOS are outdated).
# Don't forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum" 2> /dev/null

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`.
brew install gnu-sed
# Install a modern version of Bash.
brew install bash
brew install bash-completion@2

# Switch to using brew-installed bash as default shell
if ! grep -qF "${BREW_PREFIX}/bin/bash" /etc/shells; then
  echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells;
  chsh -s "${BREW_PREFIX}/bin/bash";
fi;

# Install `wget`.
brew install wget

# Install GnuPG to enable PGP-signing commits.
brew install gnupg

# Install more recent versions of some macOS tools.
brew install vim
brew install grep
brew install openssh

# Install modern CLI tools.
brew install ripgrep
brew install fd
brew install bat
brew install fzf
brew install eza
brew install jq
brew install gh
brew install git-delta
brew install htop
brew install tldr

# Install some CTF tools; see https://github.com/ctfs/write-ups.
brew install aircrack-ng
brew install bfg
brew install binutils
brew install binwalk
brew install dns2tcp
brew install fcrackzip
brew install hydra
brew install john
brew install nmap
brew install pngcheck
brew install socat
brew install sqlmap
brew install tcpflow
brew install tcpreplay
brew install tcptrace
brew install xz

# Install other useful binaries.
brew install git
brew install git-lfs
brew install ghostscript
brew install imagemagick
brew install lua
brew install pigz
brew install pv
brew install rename
brew install rlwrap
brew install ssh-copy-id
brew install tree
brew install vbindiff
brew install zopfli
brew install woff2

# Install version managers.
brew install jenv
brew install pyenv
brew install rbenv
brew install nvm

# Remove outdated versions from the cellar.
brew cleanup
