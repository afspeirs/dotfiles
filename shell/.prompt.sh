if [[ -n "$SSH_CONNECTION" ]]; then
  SHOW_HOST=true
else
  SHOW_HOST=false
fi

if [[ -n "$ZSH_VERSION" ]]; then
  setopt PROMPT_SUBST

  if $SHOW_HOST; then
    LEFT_PREFIX='%n@%m '
  else
    LEFT_PREFIX=''
  fi

  autoload -Uz vcs_info
  precmd_functions+=(vcs_info)
  # precmd() { vcs_info }
  # zstyle ':vcs_info:git:*' formats '%F{yellow}(%b)%f'
  # zstyle ':vcs_info:git:*' actionformats '%F{red}(%b|%a)%f'

  zstyle ':vcs_info:*' enable git

  # Check for modified files
  zstyle ':vcs_info:git:*' check-for-changes true

  # Symbols
  zstyle ':vcs_info:git:*' unstagedstr '!'
  zstyle ':vcs_info:git:*' stagedstr '+'

  # Format
  zstyle ':vcs_info:git:*' formats '%F{yellow}(%b%c%u)%f'
  zstyle ':vcs_info:git:*' actionformats '%F{red}(%b|%a%c%u)%f'

  PROMPT='
'"${LEFT_PREFIX}"'%F{cyan}%~%f
❯ '

  RPROMPT='${vcs_info_msg_0_}'
else
  if $SHOW_HOST; then
    HOST_PREFIX='\u@\h '
  else
    HOST_PREFIX=''
  fi

  PS1='\n'"${HOST_PREFIX}"'\[\e[36m\]\w\[\e[0m\]\n❯ '
fi
