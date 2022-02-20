
#!/usr/bin/env bash

# Get current dir (so run this script from anywhere)

export DOTFILES_DIR DOTFILES_CACHE DOTFILES_EXTRA_DIR
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOTFILES_CACHE="$DOTFILES_DIR/.cache.sh"
DOTFILES_EXTRA_DIR="$HOME/.extra"

# Make utilities available
PATH="$DOTFILES_DIR/bin:$PATH"

# Symlinks
ln -sfv "$DOTFILES_DIR/files/.profile" ~
ln -sfv "$DOTFILES_DIR/files/.screenrc" ~
ln -sfv "$DOTFILES_DIR/git/.gitconfig" ~
ln -sfv "$DOTFILES_DIR/git/.gitignore_global" ~
if [ "$(uname)" == "Darwin" ]; then
    ln -sfv "$DOTFILES_DIR/vim/.vimrc-darwin" "~/.vimrc"
else
    ln -sfv "$DOTFILES_DIR/vim/.vimrc-linux" "~/.vimrc"
fi


# Package managers & packages
if [ "$(uname)" == "Darwin" ]; then
    . "$DOTFILES_DIR/install/brew-cask.sh"
elif [ "$(uname)" == "Linux" ] && [ -e /usr/bin/apt ]; then
    . "$DOTFILES_DIR/install/apt.sh"
fi
