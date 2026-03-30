function ta() {
  local session_input session_name session_path base_name parent_name home_name host_prefix

  session_input="${1:-$PWD}"
  home_name="${HOME:t}"

  if [[ -d "$session_input" ]]; then
    session_path="${session_input:A}"
    base_name="${session_path:t}"
    parent_name="${session_path:h:t}"

    if [[ "$parent_name" == "/" || "$parent_name" == "." || "$parent_name" == "$home_name" ]]; then
      session_name="$base_name"
    else
      session_name="$parent_name-$base_name"
    fi
  else
    session_name="$session_input"
    session_path="$PWD"
  fi

  if [[ -n "$SSH_CONNECTION" ]]; then
    host_prefix="$(hostname -s)-"
    session_name="$host_prefix$session_name"
  fi

  session_name="${session_name//[^[:alnum:]._:-]/-}"
  session_name="${session_name:-main}"

  if [[ -n "$TMUX" ]]; then
    tmux new-session -Ad -s "$session_name" -c "$session_path"
    tmux switch-client -t "$session_name"
    return
  fi

  tmux new-session -A -s "$session_name" -c "$session_path"
}
