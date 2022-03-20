#!/usr/bin/bash

# Install packages
apps=(
  screen
)    

sudo apt-get install "${apps[@]}" -y
