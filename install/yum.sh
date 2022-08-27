#!/usr/bin/bash

# Install packages
apps=(
#  screen
  tmux
)    

sudo yum install "${apps[@]}" -y
