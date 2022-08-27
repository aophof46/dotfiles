#!/usr/bin/bash

# Install packages
apps=(
#  screen
  tmux
  git
)    

sudo yum install "${apps[@]}" -y
