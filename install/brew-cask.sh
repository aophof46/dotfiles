# Use ZSH shell
if [ "$(echo $SHELL)" != "/bin/zsh" ]; then
    chsh -s /bin/zsh
fi

if [ ! -f "/opt/homebrew/bin/brew" ]; then
    # Install Homebrew

    # ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

      echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/$(whoami)/.zprofile
      echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/$(whoami)/.profile
      eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# This adds the official HashiCorp Homebrew repository, which contains the Terraform package.
/opt/homebrew/bin/brew tap hashicorp/tap

/opt/homebrew/bin/brew update
/opt/homebrew/bin/brew upgrade

# Install packages
apps=(
    aerial
    android-studio
#    android-platform-tools
#    arduino
    ansible
    apfel
    balenaetcher
    bitwarden
    chafa
    discord
    ffmpeg
    geekbench
    geekbench-ai
    git
    gum
    homebrew/cask/basictex
    htop
    iterm2
    librsvg
    mole # https://github.com/tw93/Mole
    nmap
    obsidian
    pandoc
    powershell
    python
    screen
    slack
    spotify
    tree
    hashicorp/tap/terraform
    ultimaker-cura
    visual-studio-code
    vlc
    vmware-horizon-client
    vysor
    watch
    webex
    wireshark
    yt-dlp
    zoom
)

casks=(
  # mediahuman-audio-converter # doesn't exist anymore?
  arduino-ide
)

/opt/homebrew/bin/brew install "${apps[@]}"

#brew install "${casks[@]}" --casks

# Git comes with diff-highlight, but isn't in the PATH
sudo ln -sf "$(/opt/homebrew/bin/brew --prefix)/share/git-core/contrib/diff-highlight/diff-highlight" /usr/local/bin/diff-highlight
