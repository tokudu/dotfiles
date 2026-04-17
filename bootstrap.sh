#!/usr/bin/env bash
set -euo pipefail

REPO="tokudu/dotfiles"
[[ "$OSTYPE" == darwin* ]] && IS_MACOS=true || IS_MACOS=false

# ---------- output helpers ---------------------------------------------------
# Gracefully degrade if tput isn't available (e.g. non-interactive CI pipe)
_tput() { command -v tput &>/dev/null && tput "$@" 2>/dev/null || true; }
BOLD="$(_tput bold)"; GREEN="$(_tput setaf 2)"; YELLOW="$(_tput setaf 3)"
RED="$(_tput setaf 1)"; RESET="$(_tput sgr0)"

info() { echo "${BOLD}${GREEN}==>${RESET}${BOLD} $*${RESET}"; }
warn() { echo "${BOLD}${YELLOW}warning:${RESET} $*" >&2; }
die()  { echo "${BOLD}${RED}error:${RESET} $*" >&2; exit 1; }

# ---------- cleanup ----------------------------------------------------------
cleanup() {
  [[ -n "${TMPDIR_BOOTSTRAP:-}" && -d "$TMPDIR_BOOTSTRAP" ]] \
    && rm -rf "$TMPDIR_BOOTSTRAP"
}
trap cleanup EXIT

# ---------- download source tarball ------------------------------------------
TMPDIR_BOOTSTRAP="$(mktemp -d)"

info "Fetching latest release info for ${REPO}…"
RELEASE_JSON="$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" 2>/dev/null || true)"

# python3 is reliable on macOS; far more robust than grep|cut for JSON
TAG=""
if [[ -n "$RELEASE_JSON" ]]; then
  TAG="$(echo "$RELEASE_JSON" \
    | python3 -c "import sys,json; print(json.load(sys.stdin).get('tag_name',''))" \
    2>/dev/null || true)"
fi

if [[ -n "$TAG" ]]; then
  info "Downloading release ${TAG}…"
  TARBALL_URL="https://github.com/${REPO}/archive/refs/tags/${TAG}.tar.gz"
else
  warn "No release found — falling back to main branch archive."
  TARBALL_URL="https://github.com/${REPO}/archive/refs/heads/main.tar.gz"
fi

curl -fsSL -o "$TMPDIR_BOOTSTRAP/dotfiles.tar.gz" "$TARBALL_URL" \
  || die "Failed to download ${TARBALL_URL}"
tar xz -C "$TMPDIR_BOOTSTRAP" --strip-components=1 -f "$TMPDIR_BOOTSTRAP/dotfiles.tar.gz"
rm "$TMPDIR_BOOTSTRAP/dotfiles.tar.gz"

# ---------- sync dotfiles to $HOME and run setup -----------------------------
sync_and_install() {
  info "Syncing dotfiles to ${HOME}…"
  rsync \
    --exclude ".git/" \
    --exclude ".DS_Store" \
    --exclude ".osx" \
    --exclude "bootstrap.sh" \
    --exclude "README.md" \
    --exclude "LICENSE-MIT.txt" \
    --exclude ".github/" \
    --exclude "release-please-config.json" \
    --exclude ".release-please-manifest.json" \
    -avh --no-perms "$TMPDIR_BOOTSTRAP/" ~

  # Reload shell profile.
  # Disable both -e and -u: dotfiles aren't written for strict mode,
  # and a non-fatal error here shouldn't abort the whole bootstrap.
  if [[ -f ~/.bash_profile ]]; then
    info "Sourcing ~/.bash_profile…"
    set +eu
    # shellcheck disable=SC1090
    source ~/.bash_profile
    set -eu
  else
    warn "~/.bash_profile not found after sync — skipping."
  fi

  if $IS_MACOS; then
    info "Running macos.sh…"
    bash "$TMPDIR_BOOTSTRAP/macos.sh"
  fi

  info "Done."
}

# ---------- confirm and run --------------------------------------------------
if [[ "${1:-}" == "--force" || "${1:-}" == "-f" ]]; then
  sync_and_install
else
  read -rp "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
  echo
  [[ $REPLY =~ ^[Yy]$ ]] && sync_and_install
fi

unset -f sync_and_install
