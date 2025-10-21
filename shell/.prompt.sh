if [[ "$OSTYPE" == darwin* ]] || [[ -n "$SSH_CONNECTION" || -n "$SSH_CLIENT" || -n "$SSH_TTY" ]]; then
  SHOULD_SHOW_HOST=true
else
  SHOULD_SHOW_HOST=false
fi

function parse_git_branch() {
  if [ -d .git ] || git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    local BRANCH
    BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null)
    [[ -n "$BRANCH" ]] && echo "($BRANCH)"
  fi
}

if [ -n "$ZSH_VERSION" ]; then
  setopt PROMPT_SUBST

  if $SHOULD_SHOW_HOST; then
    LEFT_PREFIX='%n@%m '
  else
    LEFT_PREFIX=''
  fi

  function git_branch_prompt_zsh() {
    local branch_output
    branch_output=$(parse_git_branch)
    [[ -n "$branch_output" ]] && echo "%F{yellow}${branch_output}%f"
  }

  # Set PROMPT: [user@host] [/current/path] $
  export PROMPT="${LEFT_PREFIX}%F{cyan}%~%f $ "
  # Set RPROMPT: [(git-branch)]
  export RPROMPT='$(git_branch_prompt_zsh)'
else
  # PS1: [cyan][/current/path] [yellow][(git-branch)] $
  export PS1="\[\033[36m\]\w\[\033[00m\] \[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "
fi
