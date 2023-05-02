{ pkgs, ... }:

{
  programs.starship = {
    enable = true;
    settings = {
      # Disable the newline at the start of the prompt
      add_newline = false;
      command_timeout = 5000;
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
        vicmd_symbol = "[❮](bold green)";
      };
      cmd_duration = {
        min_time = 500;
        format = "took [$duration]($style) ";
      };
      git_status = {
        conflicted = "🏳";
        ahead = "🏎💨";
        behind = "😰";
        diverged = "😵";
        untracked = "🤷";
        stashed = "📦";
        modified = "📝";
        renamed = "👅";
        deleted = "🗑";
      };
      directory = {
        format = " in [$path]($style)[$read_only]($read_only_style) ";
        truncation_length = 4;
      };
      username = {
        style_user = "white bold";
        style_root = "yellow bold";
        format = "[$user]($style)";
        disabled = false;
        show_always = true;
      };
      hostname = {
        style = "white bold";
        ssh_only = true;
        format = "@[$hostname]($style)";
        trim_at = ".";
        disabled = false;
      };
      time = {
        disabled = true;
        use_12hr = false;
        time_format = "🕙 [ %r ]";
      };
      battery = {
        full_symbol = "🔋";
        charging_symbol = "⚡️";
        discharging_symbol = "💀";
        display = [
          {
            threshold = 10;
            style = "bold red";
          }
          {
            threshold = 15;
            style = "bold yellow";
          }
          {
            threshold = 30;
            style = "bold green";
          }
        ];
      };
    };
  };
}
