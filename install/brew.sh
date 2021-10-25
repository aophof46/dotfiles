# Install Homebrew

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/$(whoami)/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
    
    
    
brew update
brew upgrade

# Install packages

apps=(
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
    ffmpeg
    git
)

brew install "${apps[@]}"

# Git comes with diff-highlight, but isn't in the PATH
ln -sf "$(brew --prefix)/share/git-core/contrib/diff-highlight/diff-highlight" /usr/local/bin/diff-highlight
