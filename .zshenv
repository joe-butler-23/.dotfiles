# ~/.zshenv

# History files should be defined early, harmless for all shells.
export HISTFILE="$HOME/.zhistory"
export HISTSIZE=10000
export SAVEHIST=10000

# PATH (one pass, de-duplicated) — available to all shells
typeset -U path PATH
path=(
  $HOME/.npm-global/bin
  $HOME/.local/bin
  $HOME/.cargo/bin
  $HOME/go/bin
  $HOME/.opencode/bin
  $HOME/bin
  /usr/bin/vendor_perl
  $path
)
export PATH

# Safe, lightweight defaults
export EDITOR="mousepad"
export VISUAL="mousepad"

# Starship config location is safe to expose everywhere
# export STARSHIP_CONFIG="$HOME/.config/starship.toml"