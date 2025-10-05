# ~/.zshrc

# Options from Manjaro configuration
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

# Enable additional plugins
if [[ -e /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
if [[ -e /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
fi
if [[ -e /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Disable Powerline wide characters
HAS_WIDECHARS="false"

# Optimized PATH exports
export PATH="$HOME/.npm-global/bin:$HOME/.local/bin:/usr/bin/vendor_perl:$PATH"

# Conda Lazy Load
unalias conda 2>/dev/null
_lazy_load_conda() {
    unset -f conda
    export PATH="$HOME/anaconda3/bin:$PATH"
    if [ -f "$HOME/anaconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/anaconda3/etc/profile.d/conda.sh"
    fi
}
conda() {
    _lazy_load_conda
    conda "$@"
}

# Python Lazy Load
unalias python pip 2>/dev/null
_lazy_load_python() {
    unset -f python pip
    if [[ -f "$HOME/anaconda3/bin/python" ]]; then
        export PATH="$HOME/anaconda3/bin:$PATH"
    fi
}
python() {
    _lazy_load_python
    command python "$@"
}
pip() {
    _lazy_load_python
    command pip "$@"
}

# FNM Setup (fast Node version manager)
export FNM_DIR="$HOME/.local/share/fnm"
export PATH="$FNM_DIR:$PATH"
eval "$(fnm env --use-on-cd)"

# Background Load Starship & Zoxide
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# Aliases
alias stowall="$HOME/.dotfiles/stowall.sh"
alias syncdesktop="ansible-playbook -i ~/.ansible/inventory/hosts ~/.ansible/playbooks/sync_desktop.yml --ask-become-pass"
alias syncpackages="ansible-playbook -i ~/.ansible/hosts.ini .ansible/roles/sync_packages/sync_packages.yml --ask-become-pass"
alias nvim='nvim --listen /tmp/nvim'

# Editor and API Key
export EDITOR=nvim
export VISUAL=nvim
export ANTHROPIC_API_KEY="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"
export OPENAI_API_KEY="sk-BzZhq7-j5np5s4HTcEHqdMOFsLX_PN9xOFlkBFEqWoT3BlbkFJbId8q23r0_s06t8mDNJwjpI5jL4bOfrjz89WFEJlwA"
export TODOIST_API_KEY="daa251668355ad20e91c251048e1d0b0b6cd8e8f"

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

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
export PATH="$PATH:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/tools/bin"
export PATH="$HOME/.config/jarvis/bin:$PATH"
export PATH="$HOME/bin:$PATH"
alias launchapp='cd /home/joebutler/artifact2native-test/myapp && ./artifact2native.sh frontend/src/App.jsx --run'
