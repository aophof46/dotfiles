# Install Homebrew

# ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Use ZSH shell
chsh -s /bin/zsh

if [ "$(echo $SHELL)" == "/bin/zsh" ]; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/$(whoami)/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi   


brew update
brew upgrade

# Install packages
apps=(
    aerial
    android-studio
    android-platform-tools
    arduino
    balenaetcher
    discord
    git
    htop
    iterm2
    lastpass
    mediahuman-audio-converter
    powershell
    screen
    slack
    spotify
    sublime-text2
    ultimaker-cura
    visual-studio-code
    vlc
    vmware-horizon-client
    vysor
    webex
    wireshark
    zoom
)    

brew install "${apps[@]}" --cask


# Git comes with diff-highlight, but isn't in the PATH
sudo ln -sf "$(brew --prefix)/share/git-core/contrib/diff-highlight/diff-highlight" /usr/local/bin/diff-highlight
