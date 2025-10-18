# ~/.zshrc

####################
# Options & History
####################
setopt correct extendedglob nocaseglob rcexpandparam nocheckjobs \
       numericglobsort nobeep appendhistory histignorealldups \
       autocd inc_append_history histignorespace interactivecomments

# op inject settings
if command -v op >/dev/null 2>&1 && [ -S "/run/user/$UID/1password/agent.sock" ]; then
  if timeout 1s op account list >/dev/null 2>&1; then
    eval "$(op inject --in-file "$HOME/.dotfiles/secrets.zsh")"
  fi
fi

############################
# Prompt
############################
eval "$(starship init zsh)"

#####################################
# Plugins
#####################################
ZSH_AUTOSUGGEST_DEFAULT_STRATEGY=(completion history)

fpath=(/usr/share/zsh/plugins/zsh-history-substring-search $fpath)
fpath=(/usr/share/zsh/plugins/zsh-autosuggestions $fpath)

source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

################################
# Completion
################################
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' rehash true
zstyle ':completion:*' menu select
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.zsh/cache"

mkdir -p "$HOME/.zsh/cache"

_lazy_compinit() {
  unfunction _lazy_compinit 2>/dev/null
  autoload -Uz compinit
  compinit -C -d "$HOME/.zsh/cache/zcompdump-$ZSH_VERSION"
  if [[ -r "$HOME/.zsh/cache/zcompdump-$ZSH_VERSION" && ! -r "$HOME/.zsh/cache/zcompdump-$ZSH_VERSION.zwc" ]]; then
    zcompile "$HOME/.zsh/cache/zcompdump-$ZSH_VERSION"
  fi
  bindkey '^I' complete-word
  zle complete-word
}
zle -N _lazy_compinit
bindkey '^I' _lazy_compinit

########################
# Utilities & Variables
########################
# zoxide
eval "$(zoxide init zsh)"

################
# Aliases
################
alias k="kitty @ launch --type=os-window"
alias nvim='nvim --listen /tmp/nvim'

############################
# Yazi chooser + cd/open fn
############################
y() {
  local tmp_cwd tmp_pick cwd pick
  tmp_cwd=$(mktemp -t "yazi-cwd.XXXXXX")
  tmp_pick=$(mktemp -t "yazi-pick.XXXXXX")
  yazi "$@" --cwd-file "$tmp_cwd" --chooser-file "$tmp_pick"
  pick=$(<"$tmp_pick")
  if [ -n "$pick" ]; then
    nvim "$pick"
  else
    cwd=$(<"$tmp_cwd")
    if [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
      builtin cd -- "$cwd"
    fi
  fi
  rm -f -- "$tmp_cwd" "$tmp_pick"
}

############################################
# Copy last terminal output
############################################
copy_last_output() {
  /home/joebutler/bin/zsh-copy-last-output.sh
}
zle -N copy_last_output
bindkey '^ ' copy_last_output

#############
# Key binds
#############
bindkey -s "^[Q" "clear && printf '\e[3J'\n"

#############
# Lazy loading
#############

# ---- Lazy-load Node/NVM ----
if [ -d "$HOME/.nvm" ]; then
  _lazy_nvm_bootstrap() {
    unfunction _lazy_nvm_bootstrap 2>/dev/null
    unset -f node npm npx corepack yarn pnpm 2>/dev/null
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  }
  node()     { _lazy_nvm_bootstrap; command node "$@"; }
  npm()      { _lazy_nvm_bootstrap; command npm "$@"; }
  npx()      { _lazy_nvm_bootstrap; command npx "$@"; }
  corepack() { _lazy_nvm_bootstrap; command corepack "$@"; }
  yarn()     { _lazy_nvm_bootstrap; command yarn "$@"; }
  pnpm()     { _lazy_nvm_bootstrap; command pnpm "$@"; }
fi

# ---- Lazy-load Conda ----
if [ -f "$HOME/anaconda3/etc/profile.d/conda.sh" ] || [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
  _lazy_conda_bootstrap() {
    unfunction _lazy_conda_bootstrap 2>/dev/null
    unset -f conda activate 2>/dev/null
    if [ -f "$HOME/anaconda3/etc/profile.d/conda.sh" ]; then
      . "$HOME/anaconda3/etc/profile.d/conda.sh"
    elif [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
      . "$HOME/miniconda3/etc/profile.d/conda.sh"
    fi
  }
  conda()    { _lazy_conda_bootstrap; command conda "$@"; }
  activate() { _lazy_conda_bootstrap; command activate "$@"; }
fi

#############
# prexc/precmd
#############

# --- last-output tracking setup ---
LOG="$HOME/.cache/zsh-last-output.log"
ZSH_LAST_MARK_START="<<<ZSH-OUT-START>>>"
ZSH_LAST_MARK_END="<<<ZSH-OUT-END>>>"

mkdir -p "$HOME/.cache"
: >| "$LOG"

# Mark before and after every command
preexec() {
  print -r -- "$ZSH_LAST_MARK_START $(date +%s) $PWD $1" >> "$LOG"
  # Redirect stdout and stderr to log file while preserving terminal output
  exec > >(tee -a "$LOG")
  exec 2>&1
}

precmd() {
  print -r -- "$ZSH_LAST_MARK_END $(date +%s)" >> "$LOG"
  # Restore normal stdout/stderr
  exec > /dev/tty
  exec 2>&1
}[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
