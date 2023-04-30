#!/usr/bin/env zsh

if [[ $(uname -m) == 'arm64' ]]
then
    PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
else
    PATH="/usr/local/sbin:$PATH"
fi
PATH="${HOME}/bin:${PATH}:${HOME}/.krew/bin"
export PATH

# https://consoledonottrack.com/
export DO_NOT_TRACK=1

# case insensitive path-completion
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'
# partial completion suggestions
zstyle ':completion:*' list-suffixes zstyle ':completion:*' expand prefix suffix
# re-enable completion for cd ..
zstyle -e ':completion:*' special-dirs '[[ $PREFIX = (../)#(|.|..) ]] && reply=(..)'

if type brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

    autoload -Uz compinit
    compinit
fi

which pipenv > /dev/null &&  eval "$(_PIPENV_COMPLETE=zsh_source pipenv)"

## History file configuration
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
[ "$HISTSIZE" -lt 50000 ] && HISTSIZE=50000
[ "$SAVEHIST" -lt 10000 ] && SAVEHIST=10000

## History command configuration
setopt extended_history       # record timestamp of command in HISTFILE
#setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt INC_APPEND_HISTORY # append into history file
# setopt HIST_IGNORE_ALL_DUPS  # remove the older command even if it is not the previous event
setopt HIST_REDUCE_BLANKS  ## Delete empty lines from history file
setopt HIST_NO_STORE  ## Do not add history and fc commands to the history

export LANG=en_GB.UTF-8

export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_AUTO_UPDATE_SECS=86400
export HOMEBREW_NO_INSTALL_CLEANUP=0
export HOMEBREW_CASK_OPTS="--appdir=\"$HOME/Applications\" --fontdir=\"/Library/Fonts\" --no-quarantine"
[ -f ~/.zshrc_homebrew_github_token ] && source ~/.zshrc_homebrew_github_token

alias g="git"
alias k="kubectl"

if [ -f $HOME/.zkbd/$TERM-${${DISPLAY:t}:-$VENDOR-$OSTYPE} ]
then
  source $HOME/.zkbd/$TERM-${${DISPLAY:t}:-$VENDOR-$OSTYPE}
  [[ -n ${key[Home]} ]] && bindkey "${key[Home]}" beginning-of-line
  [[ -n ${key[End]} ]] && bindkey "${key[End]}" end-of-line
  [[ -n ${key[OptionLeft]} ]] && bindkey "${key[OptionLeft]}" backward-word
  [[ -n ${key[OptionRight]} ]] && bindkey "${key[OptionRight]}" forward-word
  [[ -n ${key[Delete]} ]] && bindkey "${key[Delete]}" delete-char
fi

# https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/gpg-agent/gpg-agent.plugin.zsh
export GPG_TTY=$TTY

gpg-connect-agent updatestartuptty /bye &>/dev/null
# If enable-ssh-support is set, fix ssh agent integration
if [[ $(gpgconf --list-options gpg-agent 2>/dev/null | awk -F: '$1=="enable-ssh-support" {print $10}') = 1 ]]; then
  unset SSH_AGENT_PID
  if [[ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]]; then
    export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
  fi
fi

export STARSHIP_CONFIG=$HOME/.starship.toml
eval "$(starship init zsh)"

[ -f ~/.iterm2_shell_integration.zsh ] && source ~/.iterm2_shell_integration.zsh
eval "$(direnv hook zsh)"

[ -f ~/.zshrc_local ] && source ~/.zshrc_local
