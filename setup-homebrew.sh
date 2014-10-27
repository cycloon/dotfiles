#!/bin/sh

# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update homebrew recipes
brew update

# Install GNU core utilities (those that come with OS X are outdated)
brew install coreutils

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
brew install findutils

# Install my selection
binaries=(
  rename
  trash
  node
  git
  wget
  apg
  mtr
  nmap
  wakeonlan
)

echo "installing binaries..."
brew install ${binaries[@]}

brew cleanup

brew install caskroom/cask/brew-cask
brew tap caskroom/versions

# Apps
# TODO: check my installed apps and add them here
apps=(
  sublime-text3
  dropbox
  skype
  vlc
  google-chrome
  firefox
  qlmarkdown
  qlprettypatch
  quicklook-json
  sourcetree
)

# Install apps to /Applications
# Default is: /Users/$user/Applications
echo "installing apps..."
brew cask install --appdir="/Applications" ${apps[@]}


