#!/usr/bin/env bash
set -euo pipefail

REPO="tokudu/dotfiles"

# ---------- helpers ----------------------------------------------------------

cleanup() {
	if [ -n "${TMPDIR_BOOTSTRAP:-}" ] && [ -d "$TMPDIR_BOOTSTRAP" ]; then
		rm -rf "$TMPDIR_BOOTSTRAP"
	fi
}
trap cleanup EXIT

# ---------- download latest release tarball ----------------------------------

echo "Fetching latest release from ${REPO}…"
TARBALL_URL="$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" \
	| grep '"tarball_url"' | cut -d '"' -f 4)"

if [ -z "$TARBALL_URL" ]; then
	echo "Error: could not determine the latest release tarball URL." >&2
	exit 1
fi

TMPDIR_BOOTSTRAP="$(mktemp -d)"
echo "Downloading release tarball…"
curl -fsSL "$TARBALL_URL" | tar xz -C "$TMPDIR_BOOTSTRAP" --strip-components=1

# ---------- sync dotfiles to $HOME ------------------------------------------

function doIt() {
	rsync --exclude ".git/" \
		--exclude ".DS_Store" \
		--exclude ".osx" \
		--exclude "bootstrap.sh" \
		--exclude "README.md" \
		--exclude "LICENSE-MIT.txt" \
		--exclude ".github/" \
		--exclude "release-please-config.json" \
		--exclude ".release-please-manifest.json" \
		-avh --no-perms "$TMPDIR_BOOTSTRAP/" ~;

	# Reload shell profile
	# shellcheck disable=SC1090
	source ~/.bash_profile;

	# Install Homebrew packages (brew.sh installs Homebrew itself if needed)
	if [[ "$OSTYPE" == darwin* ]]; then
		bash "$TMPDIR_BOOTSTRAP/brew.sh";
	fi

	# Install and configure macOS-specific apps
	if [[ "$OSTYPE" == darwin* ]]; then
		bash "$TMPDIR_BOOTSTRAP/macos.sh";
	fi

	# Apply macOS defaults
	if [[ "$OSTYPE" == darwin* ]] && [ -f ~/.macos ]; then
		source ~/.macos;
	fi
}

if [ "${1:-}" == "--force" ] || [ "${1:-}" == "-f" ]; then
	doIt;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset -f doIt;
