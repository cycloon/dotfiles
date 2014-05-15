#!/bin/sh

black='\033[0;30m'
white='\033[0;37m'
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;34m'
magenta='\033[0;35m'
cyan='\033[0;36m'


alias Reset="tput sgr0"      #  Reset text attributes to normal
                             #+ without clearing screen.

# Color-echo.
# Argument $1 = message
# Argument $2 = Color
cecho() {
  echo "${2}${1}"
  Reset # Reset to normal.
  return
}

# Some things taken from here
# https://github.com/mathiasbynens/dotfiles/blob/master/.osx

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo ""
cecho "#####################################"
cecho "## This script will make your Mac awesome."
cecho "## Follow the prompts and you'll be fine."
cecho "#####################################"
echo ""
echo ""
cecho "#####################################"
cecho "## Happy Hacking!"
cecho "#####################################"
echo ""
###############################################################################
# General UI/UX
###############################################################################

echo ""
cecho "Setting your computer name (as done via System Preferences → Sharing)"
cecho "What would you like it to be?"
read COMPUTER_NAME
sudo scutil --set ComputerName $COMPUTER_NAME
sudo scutil --set HostName $COMPUTER_NAME
sudo scutil --set LocalHostName $COMPUTER_NAME
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $COMPUTER_NAME

echo ""
cecho "Hiding the useless menubar icons?"
defaults write com.apple.systemuiserver menuExtras -array "/System/Library/CoreServices/Menu Extras/Bluetooth.menu" "/System/Library/CoreServices/Menu Extras/AirPort.menu" "/System/Library/CoreServices/Menu Extras/Battery.menu" "/System/Library/CoreServices/Menu Extras/Clock.menu"
sudo chmod 600 /System/Library/CoreServices/Search.bundle/Contents/MacOS/Search

echo ""
cecho "Disabling OS X Gate Keeper"
cecho "(You'll be able to install any app you want from here on, not just Mac App Store apps)"
sudo spctl --master-disable

echo ""
cecho "Increasing the window resize speed for Cocoa applications whether you like it or not"
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

echo ""
cecho "Expanding the save panel by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

echo ""
cecho "Disabling the 'Are you sure you want to open this application from the Internet?' dialog"
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Try e.g. `cd /tmp; unidecode "\x{0000}" > cc.txt; open -e cc.txt`
echo ""
cecho "Displaying ASCII control characters using caret notation in standard text views"
defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true

echo ""
cecho "Disabling system-wide resume"
defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false

echo ""
cecho "Disabling automatic termination of inactive apps"
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

echo ""
cecho "Saving to disk (not to iCloud) by default"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

echo ""
cecho "Reveal IP address, hostname, OS version, etc. when clicking the clock in the login window"
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

echo ""
cecho "Never go into computer sleep mode"
systemsetup -setcomputersleep Off > /dev/null

echo ""
cecho "Check for software updates daily, not just once per week"
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input
###############################################################################

echo ""
cecho "Increasing sound quality for Bluetooth headphones/headsets"
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

echo ""
cecho "Enabling full keyboard access for all controls (e.g. enable Tab in modal dialogs)"
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

echo ""
cecho "Disabling press-and-hold for keys in favor of key repeat "
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

echo ""
cecho "Setting a blazingly fast keyboard repeat rate (ain't nobody got time fo special chars while coding!)"
defaults write NSGlobalDomain KeyRepeat -int 0

echo ""
cecho "Disabling auto-correct"
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

echo ""
cecho "Setting trackpad & mouse speed to a reasonable number"
defaults write -g com.apple.trackpad.sca  ng 2
defaults write -g com.apple.mouse.scaling 2.5

echo ""
cecho "Turn off keyboard illumination when computer is not used for 5 minutes"
defaults write com.apple.BezelServices kDimTime -int 300

###############################################################################
# Screen
###############################################################################

echo ""
cecho "Requiring password immediately after sleep or screen saver begins"
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

echo ""
cecho "Where do you want screenshots to be stored? (hit ENTER if you want ~/Desktop as default)"
read screenshot_location
if [ -z "$1" ]
then
  echo ""
  cecho "Setting location to ~/Desktop"
  defaults write com.apple.screencapture location -string "$HOME/Desktop"
else
  echo ""
  cecho "Setting location to ~/$screenshot_location"
  defaults write com.apple.screencapture location -string "$HOME/$screenshot_location"
fi

echo ""
cecho "What format should screenshots be saved as? (hit ENTER for PNG, options: BMP, GIF, JPG, PDF, TIFF) "
read screenshot_format
if [ -z "$1" ]
then
  echo ""
  cecho "Setting screenshot format to PNG"
  defaults write com.apple.screencapture type -string "png"
else
  echo ""
  cecho "Setting screenshot format to $screenshot_format"
  defaults write com.apple.screencapture type -string "$screenshot_format"
fi


cecho "Enabling subpixel font rendering on non-Apple LCDs"
defaults write NSGlobalDomain AppleFontSmoothing -int 2

###############################################################################
# Finder
###############################################################################

echo ""
cecho "Showing icons for hard drives, servers, and removable media on the desktop"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true

echo ""
cecho "Finder: show hidden files by default?"
select yn in "Yes" "No"; do
  case $yn in
    Yes ) defaults write com.apple.Finder AppleShowAllFiles -bool true
        break;;
    No ) break;;
  esac
done

echo ""
cecho "Finder: show dotfiles?"
select yn in "Yes" "No"; do
  case $yn in
    Yes ) defaults write com.apple.finder AppleShowAllFiles TRUE
        break;;
    No ) break;;
  esac
done

echo ""
cecho "Finder: showing all filename extensions"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

echo ""
cecho "Finder: showing status bar"
defaults write com.apple.finder ShowStatusBar -bool true

echo ""
cecho "Finder: show path bar"
defaults write com.apple.finder ShowPathbar -bool true

echo ""
cecho "Finder: allowing text selection in Quick Look/Preview"
defaults write com.apple.finder QLEnableTextSelection -bool true

echo ""
cecho "Displaying full POSIX path as Finder window title?"
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

echo ""
cecho "Disabling the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

echo ""
cecho "Use column view in all Finder windows by default"
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

echo ""
cecho "Avoiding creating stupid .DS_Store files on network volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

echo ""
cecho "Disabling disk image verification"
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

echo ""
cecho "Enable snap-to-grid for icons on the desktop and in other icon views?"
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

echo ""
cecho "Setting Trash to empty securely by default"
defaults write com.apple.finder EmptyTrashSecurely -bool true


###############################################################################
# Dock & Mission Control
###############################################################################

# Wipe all (default) app icons from the Dock
# This is only really useful when setting up a new Mac, or if you don’t use
# the Dock to launch apps.
#defaults write com.apple.dock persistent-apps -array

echo ""
cecho "Setting the icon size of Dock items to 36 pixels for optimal size/screen-realestate"
defaults write com.apple.dock tilesize -int 36

echo ""
cecho "Speeding up Mission Control animations and grouping windows by application"
defaults write com.apple.dock expose-animation-duration -float 0.1
defaults write com.apple.dock "expose-group-by-app" -bool true

echo ""
cecho "Setting Dock to auto-hide and removing the auto-hiding delay"
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0

echo ""
cecho "Setting Dock to 2D mode"
defaults write com.apple.dock no-glass -boolean YES

echo ""
cecho "Pinning the Dock to the left side of the screen for most efficient use of screen realestate"
#defaults write com.apple.dock pinning -string "end"


###############################################################################
# Safari & WebKit
###############################################################################

echo ""
cecho "Disabling Safari’s thumbnail cache for History and Top Sites"
defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

echo ""
cecho "Enabling Safari’s debug menu"
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

echo ""
cecho "Making Safari’s search banners default to Contains instead of Starts With"
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

echo ""
cecho "Removing useless icons from Safari’s bookmarks bar"
defaults write com.apple.Safari ProxiesInBookmarksBar "()"

echo ""
cecho "Enabling the Develop menu and the Web Inspector in Safari"
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true

echo ""
cecho "Adding a context menu item for showing the Web Inspector in web views"
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

###############################################################################
# Address Book and iTunes
###############################################################################

echo ""
cecho "Enabling iTunes track notifications in the Dock"
defaults write com.apple.dock itunes-notifications -bool true

echo ""
cecho "Copy email addresses as 'foo@example.com' instead of 'Foo Bar <foo@example.com>' in Mail.app?"
select yn in "Yes" "No"; do
  case $yn in
    Yes ) defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false
        break;;
    No ) break;;
  esac
done

echo ""
cecho "Enabling the debug menu in Disk Utility"
defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true

###############################################################################
# Terminal
###############################################################################

echo ""
cecho "Enabling UTF-8 ONLY in Terminal.app and setting the Pro theme by default"
defaults write com.apple.terminal StringEncodings -array 4
defaults write com.apple.Terminal "Default Window Settings" -string "Pro"
defaults write com.apple.Terminal "Startup Window Settings" -string "Pro"

###############################################################################
# Time Machine
###############################################################################

echo ""
cecho "Preventing Time Machine from prompting to use new hard drives as backup volume"
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

echo ""
cecho "Disabling local Time Machine backups"
hash tmutil &> /dev/null && sudo tmutil disablelocal

###############################################################################
# Personal Additions
###############################################################################
echo ""
cecho "Deleting space hogging sleep image and disabling"
sudo rm /private/var/vm/sleepimage
sudo pmset -a hibernatemode 0

echo ""
cecho "Speed up wake from sleep to 24 hours from an hour"
# http://www.cultofmac.com/221392/quick-hack-speeds-up-retina-macbooks-wake-from-sleep-os-x-tips/
pmset -a standbydelay 86400

echo ""
cecho "Disable computer sleep and stop the display from shutting off"
sudo pmset -a sleep 0
sudo pmset -a displaysleep 0

echo ""
cecho "Disabling OS X logging of downloaded files"
cecho "For more info visit http://www.macgasm.net/2013/01/18/good-morning-your-mac-keeps-a-log-of-all-your-downloads/"
defaults write com.apple.LaunchServices LSQuarantine -bool NO

###############################################################################
# Sublime Text
###############################################################################
echo ""
cecho "Do you use Sublime Text as your editor of choice and is it installed?"
select yn in "Yes" "No"; do
  case $yn in
    Yes ) echo ""
        cecho "Linking Sublime Text command line"
        ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/subl
        echo ""
        cecho "Setting Git to use Sublime Text as default editor"
        git config --global core.editor "subl -n -w"
        echo ""
        cecho "Removing Mission Control as it interferes with Sublime Text keyboard shortcut for selecting multiple lines"
        defaults write com.apple.dock mcx-expose-disabled -bool TRUE
        break;;
    No ) break;;
  esac
done


###############################################################################
# Git
###############################################################################
echo ""
cecho "Create a nicely formatted git log command accessible via 'git lg'?"
select yn in "Yes" "No"; do
  case $yn in
    Yes ) cecho "Creating nice git log command"
        git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
        break;;
    No ) break;;
  esac
done

###############################################################################
# Kill affected applications
###############################################################################

echo ""
cecho "Done!"
echo ""
echo ""
cecho "###############################################################################"
echo ""
echo ""
cecho "Note that some of these changes require a logout/restart to take effect."
cecho "Killing some open applications in order to take effect."
echo ""

find ~/Library/Application\ Support/Dock -name "*.db" -maxdepth 1 -delete
for app in Finder Dock Mail Safari iTunes iCal Address\ Book SystemUIServer; do
  killall "$app" > /dev/null 2>&1
done
