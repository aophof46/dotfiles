#!/usr/bin/bash

brew update
brew upgrade

# Install packages
apps=(
  screen
)    

#brew install "${casks[@]}" --cask

sudo apt-get install "${apps[@]}"
