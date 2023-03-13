#!/usr/bin/bash

# Install packages
apps=(
  screen
  sshpass
)    

sudo apt-get install "${apps[@]}" -y
