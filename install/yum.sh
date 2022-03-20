#!/usr/bin/bash

# Install packages
apps=(
  screen
)    

sudo yum install "${apps[@]}" -y
