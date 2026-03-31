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
# Little Snitch — https://obdev.at/products/littlesnitch                     #
###############################################################################

brew install --cask little-snitch

# Note: Little Snitch requires a system extension approval and likely a reboot.
# Configuration is done via its own CLI rather than `defaults write`.
# The CLI lives at:
#   /Applications/Little Snitch.app/Contents/Components/littlesnitch
# You must first enable Terminal access:
#   Little Snitch > Settings > Security > Allow access via Terminal

LS_CLI="/Applications/Little Snitch.app/Contents/Components/littlesnitch"
if [ -x "$LS_CLI" ]; then
	# Allow CLI access (required for the commands below)
	sudo "$LS_CLI" write-preference allowCommandLineAccess true

	# Allow GUI scripting (AppleScript/automation)
	sudo "$LS_CLI" write-preference allowGUIScripting true
fi

###############################################################################
# AppCleaner — https://freemacsoft.net/appcleaner                            #
###############################################################################

brew install --cask appcleaner

# Enable SmartDelete (automatically detect when apps are moved to Trash)
defaults write com.nektony.AppCleaner SUEnableAutomaticChecks -bool true

# Protect default Apple apps from removal
defaults write com.nektony.AppCleaner SIPProtectionEnabled -bool true

echo "Done. Stats, Little Snitch, and AppCleaner have been installed and configured."
echo "Note: Little Snitch requires a system extension approval in System Settings > Privacy & Security."
