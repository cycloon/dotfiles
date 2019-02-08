#!/bin/sh

# Check for Atom,
# Install if we don't have it
if test ! $(which atom); then
  echo "Installing atom..."
  brew cask install atom
fi


if test ! $(which apm); then
  echo "Error: could not find atom package manager"
  exit 1
fi


# setup via Brewfile
apm install --packages-file atom.pkglst 
