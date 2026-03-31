# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH";

# Resolve Homebrew prefix once for use throughout this file.
if command -v brew &> /dev/null; then
	BREW_PREFIX="$(brew --prefix)";
else
	BREW_PREFIX="";
fi;

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don't want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null;
done;

# Add tab completion for many Bash commands
if [ -n "$BREW_PREFIX" ] && [ -r "$BREW_PREFIX/etc/profile.d/bash_completion.sh" ]; then
	# Ensure existing Homebrew v1 completions continue to work
	export BASH_COMPLETION_COMPAT_DIR="$BREW_PREFIX/etc/bash_completion.d";
	source "$BREW_PREFIX/etc/profile.d/bash_completion.sh";
elif [ -f /etc/bash_completion ]; then
	source /etc/bash_completion;
fi;

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null; then
	complete -o default -o nospace -F _git g;
fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults;

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari Music SystemUIServer Terminal" killall;

###############################################################################
# Version managers                                                            #
###############################################################################

# jenv (Java version manager)
if command -v jenv &> /dev/null; then
	export PATH="$HOME/.jenv/bin:$PATH";
	eval "$(jenv init -)";
fi;

# pyenv (Python version manager)
if command -v pyenv &> /dev/null; then
	export PYENV_ROOT="$HOME/.pyenv";
	export PATH="$PYENV_ROOT/bin:$PATH";
	eval "$(pyenv init -)";
fi;

# rbenv (Ruby version manager)
if command -v rbenv &> /dev/null; then
	eval "$(rbenv init -)";
fi;

# nvm (Node version manager)
export NVM_DIR="$HOME/.nvm";
if [ -n "$BREW_PREFIX" ] && [ -s "$BREW_PREFIX/opt/nvm/nvm.sh" ]; then
	source "$BREW_PREFIX/opt/nvm/nvm.sh";
	[ -s "$BREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && source "$BREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm";
elif [ -s "$NVM_DIR/nvm.sh" ]; then
	source "$NVM_DIR/nvm.sh";
	[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion";
fi;

# fvm (Flutter version manager) — installed via `dart pub global activate fvm`
if [ -d "$HOME/fvm/default/bin" ]; then
	export PATH="$HOME/fvm/default/bin:$PATH";
fi;
if [ -d "$HOME/.pub-cache/bin" ]; then
	export PATH="$HOME/.pub-cache/bin:$PATH";
fi;
