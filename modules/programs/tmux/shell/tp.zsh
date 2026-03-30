function tp() {
  local -a search_roots git_dirs projects
  local selected_project

  if ! command -v fd >/dev/null 2>&1; then
    print -u2 "tp: fd is required"
    return 1
  fi

  if ! command -v fzf >/dev/null 2>&1; then
    print -u2 "tp: fzf is required"
    return 1
  fi

  if [[ -n "$SESSIONIZER_DIR" ]]; then
    search_roots=("$SESSIONIZER_DIR")
  else
    [[ -d "$HOME/github" ]] && search_roots+=("$HOME/github")
  fi

  if (( ${#search_roots} == 0 )); then
    print -u2 "tp: no project roots found"
    return 1
  fi

  git_dirs=("${(@f)$(fd --hidden --follow --no-ignore --type d '^\.git$' "${search_roots[@]}" 2>/dev/null)}")

  if (( ${#git_dirs} == 0 )); then
    print -u2 "tp: no git projects found"
    return 1
  fi

  projects=("${(@u)git_dirs:h}")
  selected_project=$(printf '%s\n' "${projects[@]}" | fzf --prompt='Project > ' --height=40% --layout=reverse --border)

  if [[ -z "$selected_project" ]]; then
    return 0
  fi

  ta "$selected_project"
}
