

# ============================================================================
# Dotfiles
# ============================================================================
DOTFILES="$HOME/git/dotfiles"

[ -d "$DOTFILES/aliases" ] && for f in "$DOTFILES"/aliases/*.zsh(N); do [ -r "$f" ] && source "$f"; done
[ -d "$DOTFILES/functions" ] && for f in "$DOTFILES"/functions/*.zsh(N); do [ -r "$f" ] && source "$f"; done


# ============================================================================
# History
# ============================================================================
export HISTFILESIZE=1000000000
export HISTSIZE=1000000
setopt HIST_IGNORE_ALL_DUPS HIST_FIND_NO_DUPS HIST_SAVE_NO_DUPS

# ============================================================================
# PATH
# ============================================================================
export PATH="/opt/homebrew/bin:$DOTFILES/bin:$PATH"


# ============================================================================
# Welcome Screen
# ============================================================================
if [[ -o interactive ]] && [[ -z "$DOTFILES_NO_WELCOME" ]]; then
    welcome
fi


