#!/bin/sh

# Settings
#COMPUTER_NAME = "lightex




# Some things taken from here
# https://github.com/mathiasbynens/dotfiles/blob/master/.osx

# Set the colours you can use
black='\033[0;30m'
white='\033[0;37m'
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;34m'
magenta='\033[0;35m'
cyan='\033[0;36m'


#  Reset text attributes to normal + without clearing screen.
alias Reset="tput sgr0"

# Color-echo.
# arg $1 = message
# arg $2 = Color
cecho() {
  echo "${2}${1}"
  Reset # Reset to normal.
  return
}

sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# General UI/UX
###############################################################################

#echo ""
#echo "Setting the hostname to $COMPUTER_NAME"
#
#sudo scutil --set ComputerName $COMPUTER_NAME
#sudo scutil --set HostName $COMPUTER_NAME
#sudo scutil --set LocalHostName $COMPUTER_NAME
#sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $COMPUTER_NAME

echo ""
echo "Setting dark theme of yosemite"
sudo defaults write /Library/Preferences/.GlobalPreferences AppleInterfaceTheme Dark

echo ""
echo "Hide the User, and Date entries in menu bar"
for domain in ~/Library/Preferences/ByHost/com.apple.systemuiserver.*; do
    defaults write "${domain}" dontAutoLoad -array \
  "/System/Library/CoreServices/Menu Extras/User.menu"
  "/System/Library/CoreServices/Menu Extras/Clock.menu"
done

defaults write com.apple.systemuiserver menuExtras -array \
  "/System/Library/CoreServices/Menu Extras/Bluetooth.menu" \
  "/System/Library/CoreServices/Menu Extras/AirPort.menu" \
  "/System/Library/CoreServices/Menu Extras/Volume.menu" \
  "/System/Library/CoreServices/Menu Extras/Battery.menu"



echo ""
echo "Increasing the window resize speed for Cocoa applications"
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

echo ""
echo "Expanding the save panel by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

echo ""
echo "Automatically quit printer app once the print jobs complete"
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Try e.g. `cd /tmp; unidecode "\x{0000}" > cc.txt; open -e cc.txt`
echo ""
echo "Displaying ASCII control characters using caret notation in standard text views"
defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true

echo ""
echo "Save to disk, rather than iCloud, by default?"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

echo ""
echo "Check for software updates daily, not just once per week"
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

echo ""
echo "Removing duplicates in the 'Open With' menu"
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

# Set Help Viewer windows to non-floating mode
defaults write com.apple.helpviewer DevMode -bool true


###############################################################################
# General Power and Performance modifications
###############################################################################

echo ""
echo "Disabling the annoying backswipe in Chrome"
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false


################################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input
###############################################################################

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1


echo ""
echo "Increasing sound quality for Bluetooth headphones/headsets"
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

echo ""
echo "Enabling full keyboard access for all controls (enable Tab in modal dialogs, menu windows, etc.)"
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

echo ""
echo "Disabling press-and-hold for special keys in favor of key repeat"
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

echo ""
echo "Setting a blazingly fast keyboard repeat rate"
defaults write NSGlobalDomain KeyRepeat -float 0.000000000001

echo ""
echo "Setting trackpad & mouse speed to a reasonable number"
defaults write -g com.apple.mouse.scaling 1
defaults write -g com.apple.mouse.scaling 2.5

echo ""
echo "Turn off keyboard illumination when computer is not used for 5 minutes"
defaults write com.apple.BezelServices kDimTime -int 300

# Set the timezone; see `sudo systemsetup -listtimezones` for other values
sudo systemsetup -settimezone "Europe/Berlin" > /dev/null



###############################################################################
# Screen
###############################################################################

echo ""
echo "Requiring password immediately after sleep or screen saver begins"
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

echo ""
echo "Setting location for screenshots to ~/Desktop"
defaults write com.apple.screencapture location -string "$HOME/Desktop"

echo ""
echo "Setting screenshot format to PNG"
defaults write com.apple.screencapture type -string "png"

echo ""
echo "Enabling subpixel font rendering on non-Apple LCDs"
defaults write NSGlobalDomain AppleFontSmoothing -int 2

###############################################################################
# Finder
###############################################################################

echo "Show all filename extensions in Finder by default"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

echo ""
echo "Show status bar in Finder by default"
defaults write com.apple.finder ShowStatusBar -bool true

echo ""
echo "Display full POSIX path as Finder window title"
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

echo ""
echo "Disable the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

echo ""
echo "Use column view in all Finder windows by default"
defaults write com.apple.finder FXPreferredViewStyle clmv

echo ""
echo "Avoid creation of .DS_Store files on network volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

echo ""
echo "Allowing text selection in Quick Look/Preview in Finder by default"
defaults write com.apple.finder QLEnableTextSelection -bool true

echo ""
echo "Enabling snap-to-grid for icons on the desktop and in other icon views"
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist


# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Enable AirDrop over Ethernet and on unsupported Macs running Lion
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true


###############################################################################
# Dock & Mission Control
###############################################################################

# Enable highlight hover effect for the grid view of a stack (Dock)
defaults write com.apple.dock mouse-over-hilite-stack -bool true


echo ""
echo "Setting the icon size of Dock items to 36 pixels for optimal size/screen-realestate"
defaults write com.apple.dock tilesize -int 36

echo ""
echo "Speeding up Mission Control animations and grouping windows by application"
defaults write com.apple.dock expose-animation-duration -float 0.1
defaults write com.apple.dock "expose-group-by-app" -bool true

echo ""
echo "Set Dock to auto-hide and remove the auto-hiding delay"
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0

# Disable Dashboard
defaults write com.apple.dashboard mcx-disabled -bool true

# Don’t show Dashboard as a Space
defaults write com.apple.dock dashboard-in-overlay -bool true

# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Hot corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center

# Top left screen corner → Mission Control
defaults write com.apple.dock wvous-tl-corner -int 3
defaults write com.apple.dock wvous-tl-modifier -int 0
# Top right screen corner → Desktop
defaults write com.apple.dock wvous-tr-corner -int 2
defaults write com.apple.dock wvous-tr-modifier -int 0
# Bottom left screen corner → Start screen saver
defaults write com.apple.dock wvous-bl-corner -int 4
defaults write com.apple.dock wvous-bl-modifier -int 5


# Show recent items(Applications, Documents etc.) on Dock
defaults write com.apple.dock persistent-others -array-add '{ "tile-data" = { "list-type" = 1; }; "tile-type" = "recents-tile"; }'

# Reset Launchpad, but keep the desktop wallpaper intact
find "${HOME}/Library/Application Support/Dock" -name "*-*.db" -maxdepth 1 -delete



###############################################################################
# Safari & WebKit
###############################################################################

echo ""
echo "Hiding Safari's bookmarks bar by default"
defaults write com.apple.Safari ShowFavoritesBar -bool false

echo ""
echo "Hiding Safari's sidebar in Top Sites"
defaults write com.apple.Safari ShowSidebarInTopSites -bool false

echo ""
echo "Enabling Safari's debug menu"
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

echo ""
echo "Making Safari's search banners default to Contains instead of Starts With"
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

echo ""
echo "Enabling the Develop menu and the Web Inspector in Safari"
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true

echo ""
echo "Adding a context menu item for showing the Web Inspector in web views"
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# Show the full URL in the address bar (note: this still hides the scheme)
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

# Prevent Safari from opening ‘safe’ files automatically after downloading
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false




###############################################################################
# Mail
###############################################################################

echo ""
echo "Setting email addresses to copy as 'foo@example.com' instead of 'Foo Bar <foo@example.com>' in Mail.app"
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false


###############################################################################
# Time Machine
###############################################################################

echo ""
echo "Prevent Time Machine from prompting to use new hard drives as backup volume"
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true


###############################################################################
# Messages                                                                    #
###############################################################################

echo ""
echo "Disable automatic emoji substitution in Messages.app? (i.e. use plain text smileys)"
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticEmojiSubstitutionEnablediMessage" -bool false


###############################################################################
# Photos                                                                      #
###############################################################################

# Prevent Photos from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

###############################################################################
# Sublime Text
###############################################################################
echo ""
echo "Linking Sublime Text for command line usage as subl"
ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/subl

echo ""
echo "Setting Git to use Sublime Text as default editor"
git config --global core.editor "atom -n -w"


###############################################################################
# Kill affected applications
###############################################################################

echo ""
cecho "Done!" $cyan
echo ""
echo ""
cecho "################################################################################" $white
echo ""
echo ""
cecho "Note that some of these changes require a logout/restart to take effect." $red
cecho "Killing some open applications in order to take effect." $red
echo ""

find ~/Library/Application\ Support/Dock -name "*.db" -maxdepth 1 -delete
for app in "Activity Monitor" "Address Book" "Calendar" "Contacts" "cfprefsd" \
  "Dock" "Finder" "Mail" "Messages" "Safari" "SystemUIServer" \
  "Terminal" "Transmission"; do
  killall "${app}" > /dev/null 2>&1
done
