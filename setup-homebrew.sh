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
  sshfs
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

# Apps
# TODO: check my installed apps and add them here
apps=(
  acorn
  dropbox
  google-chrome
  firefox
  qlmarkdown
  qlprettypatch
  sublime-text3
  vlc
  quicklook-json
  skype
)

# Install apps to /Applications
# Default is: /Users/$user/Applications
echo "installing apps..."
brew cask install --appdir="/Applications" ${apps[@]}

