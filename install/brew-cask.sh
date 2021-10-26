# Install Homebrew

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"


if [ "$(echo $SHELL)" == "/bin/zsh" ]; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/$(whoami)/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi   


brew update
brew upgrade

# Install packages
apps=(
    git
    screen
    aerial
    arduino
    iterm2
    sublime-text2
    vmware-horizon-client
    android-studio
    balenaetcher
    powershell
    visual-studio-code
    dockutil
    vlc
)

brew install "${apps[@]}" --cask

# Git comes with diff-highlight, but isn't in the PATH
sudo ln -sf "$(brew --prefix)/share/git-core/contrib/diff-highlight/diff-highlight" /usr/local/bin/diff-highlight
