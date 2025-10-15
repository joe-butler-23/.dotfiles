# ~/.zshrc

# Options
setopt correct
setopt extendedglob
setopt nocaseglob
setopt rcexpandparam
setopt nocheckjobs
setopt numericglobsort
setopt nobeep
setopt appendhistory
setopt histignorealldups
setopt autocd
setopt inc_append_history
setopt histignorespace

zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' rehash true
zstyle ':completion:*' menu select
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

HISTFILE=~/.zhistory
HISTSIZE=10000
SAVEHIST=10000

STARSHIP_CONFIG=${HOME}/.config/starship.toml
eval "$(starship init zsh)"

# Download Znap, if it's not there yet.
[[ -r ~/Repos/znap/znap.zsh ]] || \
    git clone --depth 1 -- \
        https://github.com/marlonrichert/zsh-snap.git ~/Repos/znap
source ~/Repos/znap/znap.zsh  # Start Znap

# Enable additional plugins with znap source
znap source zsh-users/zsh-syntax-highlighting
znap source zsh-users/zsh-history-substring-search
znap source zsh-users/zsh-autosuggestions

# Disable Powerline wide characters
HAS_WIDECHARS="false"

# Optimized PATH exports
export PATH="$HOME/.npm-global/bin:$HOME/.local/bin:/usr/bin/vendor_perl:$PATH"

# Conda Lazy Load
# unalias conda 2>/dev/null
# _lazy_load_conda() {
#     unset -f conda
#     export PATH="$HOME/anaconda3/bin:$PATH"
#     if [ -f "$HOME/anaconda3/etc/profile.d/conda.sh" ]; then
#         . "$HOME/anaconda3/etc/profile.d/conda.sh"
#     fi
# }
# conda() {
#     _lazy_load_conda
#     conda "$@"
# }

# Python Lazy Load
# unalias python pip 2>/dev/null
# _lazy_load_python() {
#     unset -f python pip
#     if [[ -f "$HOME/anaconda3/bin/python" ]]; then
#         export PATH="$HOME/anaconda3/bin:$PATH"
#     fi
# }
# python() {
#     _lazy_load_python
#     command python "$@"
# }
# pip() {
#     _lazy_load_python
#     command pip "$@"
# }
# Background Load Starship
eval "$(starship init zsh)"

# Zoxide Lazy Load
unalias zoxide 2>/dev/null # Unalias zoxide if it's an alias
_lazy_load_zoxide() {
    unset -f zoxide # Unset the function once loaded
    eval "$(zoxide init zsh)"
}
zoxide() { # Assuming 'zoxide' is the primary command
    _lazy_load_zoxide
    command zoxide "$@"
}

export KITTY_LISTEN_ON="unix:/tmp/kitty"

# Aliases
alias k="kitty @ launch --type=os-window"

alias nvim='nvim --listen /tmp/nvim'

# Editor
export EDITOR=mousepad
export VISUAL=mousepad

# API Keys: formatis op://vault/item/field
export ANTHROPIC_API_KEY="op://APIs/Anthropic API Key/password"
export OPENAI_API_KEY="op://APIs/OpenAI API Key/password"
export TODOIST_API_KEY="op://APIs/Todoist API Key/password"
export GEMINI_API_KEY="op://APIs/Gemini API Key/password"

# Yazi: File manager and directory jump
function y() {
  local tmp_cwd tmp_pick cwd pick

  # 1) Create two temp files (no spaces around =):
  tmp_cwd=$(mktemp -t "yazi-cwd.XXXXXX")
  tmp_pick=$(mktemp -t "yazi-pick.XXXXXX")

  # 2) Launch yazi in chooser+cwd mode:
  yazi "$@" \
    --cwd-file    "$tmp_cwd" \
    --chooser-file "$tmp_pick"

  # 3) Read the “pick” file first:
  pick=$(<"$tmp_pick")
  if [ -n "$pick" ]; then
    # You selected a file ⇒ open it
    nvim "$pick"
  else
    # Otherwise check if you changed directory
    cwd=$(<"$tmp_cwd")
    if [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
      builtin cd -- "$cwd"
    fi
  fi

  # 4) Clean up
  rm -f -- "$tmp_cwd" "$tmp_pick"
}

# Copy last terminal output using kitten and wl-copy
copy_last_output() {
  kitten @ get-text --extent=last_non_empty_output | wl-copy > /dev/null 2>&1
}
zle -N copy_last_output
bindkey '^ ' copy_last_output

# Quick clear binding
bindkey -s "^[Q" "clear && printf '\e[3J'\n"

# Zsh autosuggest behavior
ZSH_AUTOSUGGEST_DEFAULT_STRATEGY=(completion history)
export PATH="$HOME/.cargo/bin:$PATH"
export PATH=$HOME/go/bin:$PATH

export PATH="$HOME/bin:$PATH"
# export PATH="$HOME/.venv/bin:$PATH"

# opencode
export PATH=/home/joebutler/.opencode/bin:$PATH

. "$HOME/.local/share/../bin/env"
export PATH="$HOME/.local/bin:$PATH"
if uwsm check may-start; then
    exec uwsm start hyprland-uwsm.desktop
fi

# GNOME Keyring integration for UWSM
if [ -n "$DESKTOP_SESSION" ]; then
    eval $(/usr/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh)
    export GNOME_KEYRING_CONTROL
    export GNOME_KEYRING_PID
    export GPG_AGENT_INFO
    export SSH_AUTH_SOCK
fi
