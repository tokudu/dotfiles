#!/usr/bin/env bash

# Install and configure macOS-specific applications.
# Run after brew.sh — requires Homebrew to be installed.

if [[ "$OSTYPE" != darwin* ]]; then
	echo "macos.sh is only supported on macOS." >&2
	exit 1
fi

###############################################################################
# Stats — https://github.com/exelban/stats                                   #
###############################################################################

brew install stats
brew install btop
brew install --cask malwarebytes
brew install --cask rectangle

# Enable the modules you want in the menu bar
defaults write eu.exelban.Stats CPU_state -bool true
defaults write eu.exelban.Stats GPU_state -bool true
defaults write eu.exelban.Stats RAM_state -bool true
defaults write eu.exelban.Stats Disk_state -bool true
defaults write eu.exelban.Stats Network_state -bool true
defaults write eu.exelban.Stats Battery_state -bool true
defaults write eu.exelban.Stats Sensors_state -bool false
defaults write eu.exelban.Stats Bluetooth_state -bool false

# Update interval in seconds
defaults write eu.exelban.Stats CombinedModules -bool false
defaults write eu.exelban.Stats update_interval -int 3

# CPU widget: show as mini bar chart
defaults write eu.exelban.Stats CPU_widget -string "mini"

# RAM widget: show as mini bar chart
defaults write eu.exelban.Stats RAM_widget -string "mini"

# Network widget: show speed with arrows
defaults write eu.exelban.Stats Network_widget -string "speed"

# Battery widget: show percentage with icon
defaults write eu.exelban.Stats Battery_widget -string "percentage"

# Check for updates automatically
defaults write eu.exelban.Stats SUEnableAutomaticChecks -bool true

# Start at login
defaults write eu.exelban.Stats runAtLoginInitialized -bool true

###############################################################################
# Little Snitch Mini — https://obdev.at/products/littlesnitch-mini           #
###############################################################################

brew install --cask little-snitch-mini

# Check for updates automatically
defaults write at.obdev.LittleSnitchMini SUEnableAutomaticChecks -bool true

###############################################################################
# AppCleaner — https://freemacsoft.net/appcleaner                            #
###############################################################################

brew install --cask appcleaner

echo "Done. Stats, Little Snitch Mini, and AppCleaner have been installed and configured."
