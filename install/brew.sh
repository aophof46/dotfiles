# Install Homebrew

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"


brew update
brew upgrade

# Install packages

apps=(
    git
    screen
)

brew install "${apps[@]}"

# Git comes with diff-highlight, but isn't in the PATH
sudo ln -sf "$(brew --prefix)/share/git-core/contrib/diff-highlight/diff-highlight" /usr/local/bin/diff-highlight
