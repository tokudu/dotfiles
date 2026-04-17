# tokudu's dotfiles

Forked from [Mathias Bynens' dotfiles](https://github.com/mathiasbynens/dotfiles) with modernizations for current macOS and tooling.

![Screenshot of my shell prompt](https://i.imgur.com/EkEtphC.png)

## Changes from upstream

### Modernized for current macOS
- **System Settings**: Updated `.macos` from "System Preferences" (pre-Ventura) to "System Settings"
- **Removed dead defaults**: Dashboard (removed in Catalina), Notification Center unload (broken since Big Sur), sleep image manipulation (ineffective on APFS), `tmutil disablelocal` (removed in Sierra)
- **Removed discontinued apps**: Twitter.app, Tweetbot.app, Spectacle, SizeUp

### Updated tooling
- **Python 3**: Replaced all Python 2 usage (`SimpleHTTPServer`, `urllib`) with Python 3 equivalents
- **Homebrew**: Removed all deprecated `--with-*` flags; fixed renamed formulae (`bash-completion@2`, `ghostscript`)
- **Modern CLI tools**: Added `ripgrep`, `fd`, `bat`, `fzf`, `eza`, `jq`, `gh`, `git-delta`, `htop`, `tlrc`
- **Removed obsolete packages**: `ack`, `p7zip`, `hashpump`, `cifer`, `dex2jar`, `foremost`, `knock`, `screen`, `sfnt2woff`, etc.

### Version managers
Added `jenv`, `pyenv`, `rbenv`, `nvm`, and `fvm` support with shell initialization in `.bash_profile` (all guarded by existence checks — no-ops if not installed).

### One-liner bootstrap
Reworked `bootstrap.sh` to download the latest GitHub release tarball — no git clone required. Automatically installs Homebrew, packages, and applies macOS defaults:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/tokudu/dotfiles/main/bootstrap.sh)
```

### Automated releases
Added [release-please](https://github.com/googleapis/release-please) GitHub Action for automatic versioned releases on merge to `main`.

## Installation

**Warning:** If you want to give these dotfiles a try, you should first fork this repository, review the code, and remove things you don't want or need. Don't blindly use my settings unless you know what that entails. Use at your own risk!

### Quick install (recommended)

Run the one-liner to download the latest release, sync dotfiles, install Homebrew + packages, and apply macOS defaults:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/tokudu/dotfiles/main/bootstrap.sh)
```

To skip the confirmation prompt:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/tokudu/dotfiles/main/bootstrap.sh) -f
```

### Specify the `$PATH`

If `~/.path` exists, it will be sourced along with the other files, before any feature testing (such as [detecting which version of `ls` is being used](https://github.com/mathiasbynens/dotfiles/blob/aff769fd75225d8f2e481185a71d5e05b76002dc/.aliases#L21-L26)) takes place.

Here's an example `~/.path` file that adds `/usr/local/bin` to the `$PATH`:

```bash
export PATH="/usr/local/bin:$PATH"
```

### Add custom commands without creating a new fork

If `~/.extra` exists, it will be sourced along with the other files. You can use this to add a few custom commands without the need to fork this entire repository, or to add commands you don't want to commit to a public repository.

For example, your `~/.extra` might contain git credentials:

```bash
# Git credentials
# Not in the repository, to prevent people from accidentally committing under my name
GIT_AUTHOR_NAME="Your Name"
GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
git config --global user.name "$GIT_AUTHOR_NAME"
GIT_AUTHOR_EMAIL="you@example.com"
GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
git config --global user.email "$GIT_AUTHOR_EMAIL"
```

### Sensible macOS defaults

When setting up a new Mac, you may want to set some sensible macOS defaults:

```bash
./.macos
```

### Install macOS tooling

When setting up a new Mac, `macos.sh` installs Homebrew if needed, installs the CLI tools and apps used by these dotfiles, and applies the app-specific macOS defaults:

```bash
./macos.sh
```

Some of the functionality of these dotfiles depends on formulae installed by `macos.sh`. If you don't plan to run it, you should look carefully through the script and manually install any particularly important ones. A good example is Bash/Git completion: the dotfiles use a special version from Homebrew.

## Feedback

Suggestions/improvements
[welcome](https://github.com/tokudu/dotfiles/issues)!

## Thanks to...

* [Mathias Bynens](https://mathiasbynens.be/) for the [original dotfiles](https://github.com/mathiasbynens/dotfiles) this fork is based on
* @ptb and [his _macOS Setup_ repository](https://github.com/ptb/mac-setup)
* [Ben Alman](http://benalman.com/) and his [dotfiles repository](https://github.com/cowboy/dotfiles)
* [Cătălin Mariș](https://github.com/alrra) and his [dotfiles repository](https://github.com/alrra/dotfiles)
* [Gianni Chiappetta](https://butt.zone/) for sharing his [amazing collection of dotfiles](https://github.com/gf3/dotfiles)
* [Jan Moesen](http://jan.moesen.nu/) and his [ancient `.bash_profile`](https://gist.github.com/1156154) + [shiny _tilde_ repository](https://github.com/janmoesen/tilde)
* Lauri 'Lri' Ranta for sharing [loads of hidden preferences](https://web.archive.org/web/20161104144204/http://osxnotes.net/defaults.html)
* [Matijs Brinkhuis](https://matijs.brinkhu.is/) and his [dotfiles repository](https://github.com/matijs/dotfiles)
* [Nicolas Gallagher](http://nicolasgallagher.com/) and his [dotfiles repository](https://github.com/necolas/dotfiles)
* [Sindre Sorhus](https://sindresorhus.com/)
* [Tom Ryder](https://sanctum.geek.nz/) and his [dotfiles repository](https://sanctum.geek.nz/cgit/dotfiles.git/about)
* [Kevin Suttle](http://kevinsuttle.com/) and his [dotfiles repository](https://github.com/kevinSuttle/dotfiles) and [macOS-Defaults project](https://github.com/kevinSuttle/macOS-Defaults), which aims to provide better documentation for [`~/.macos`](https://mths.be/macos)
* [Haralan Dobrev](https://hkdobrev.com/)
* Anyone who [contributed a patch](https://github.com/mathiasbynens/dotfiles/contributors) or [made a helpful suggestion](https://github.com/mathiasbynens/dotfiles/issues)
