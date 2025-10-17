function parse_git_branch() {
  local branch
  branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  [[ -n "$branch" ]] && echo "($branch)"
}

# Check if the ZSH_VERSION variable is set. If it is, we are in Zsh.
if [ -n "$ZSH_VERSION" ]; then
  # This is ZSH. Use Zsh's native prompt syntax.
  PROMPT='%F{cyan}%~%f %F{yellow}$(parse_git_branch)%f $ '
else
  # This is BASH. Use Bash's PS1 syntax.
  export PS1="\[\033[36m\]\w\[\033[00m\] \[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "
fi
