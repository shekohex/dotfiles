{ pkgs, config, ... }:
let
  tmuxWhichKeyScript = pkgs.writeShellScript "tmux-which-key-init.sh" ''
    set -euo pipefail
    export PATH="${pkgs.coreutils}/bin:$PATH"
    exec "${pkgs.tmuxPlugins.tmux-which-key.rtp}"
  '';

  opensessionsSrc = pkgs.fetchFromGitHub {
    owner = "Ataraxy-Labs";
    repo = "opensessions";
    rev = "8eed564e863e9c115f16a5d67370cc6223009b64";
    hash = "sha256-JSJx9Rx/SunS46/IFB/ytmKBElZtbrymKODl2GBGVUI=";
  };

  opensessionsPatchedSrc = pkgs.runCommand "opensessions-source-patched" { } ''
    cp -R ${opensessionsSrc} $out
    chmod -R u+w $out
    substituteInPlace "$out/packages/mux/providers/zellij/src/provider.ts" \
      --replace-fail 'const zellijBin = "/opt/homebrew/bin/zellij";' 'const zellijBin = process.env.ZELLIJ_BIN ?? "zellij";' \
      --replace-fail 'const tmuxBin = "/opt/homebrew/bin/tmux";' 'const tmuxBin = process.env.TMUX_BIN ?? "tmux";'
  '';

  opensessionsDataDir = "${config.xdg.dataHome}/opensessions/plugin";

  tmuxWhichKeyYaml = builtins.replaceStrings
    [ "__OPENSESSIONS_DIR__" ]
    [ opensessionsDataDir ]
    (builtins.readFile ./tmux-which-key.yaml);

  tmuxWhichKeyConfig = pkgs.writeText "tmux-which-key-config.yaml" tmuxWhichKeyYaml;

  tmuxWhichKeyInit = pkgs.runCommand "tmux-which-key-init.tmux"
    {
      nativeBuildInputs = [ pkgs.python3 ];
    }
    ''
      ${pkgs.python3}/bin/python3 ${pkgs.tmuxPlugins.tmux-which-key}/share/tmux-plugins/tmux-which-key/plugin/build.py \
        ${tmuxWhichKeyConfig} \
        $out
    '';

  opensessionsScript = pkgs.writeShellScript "opensessions-init.sh" ''
    set -euo pipefail
    export PATH="${pkgs.coreutils}/bin:${pkgs.bun}/bin:$PATH"

    src="${opensessionsPatchedSrc}"
    target="${opensessionsDataDir}"
    version="8eed564e863e9c115f16a5d67370cc6223009b64"
    stamp="$target/.version"

    mkdir -p "$(dirname "$target")"

    if [[ ! -f "$stamp" || "$(cat "$stamp" 2>/dev/null)" != "$version" ]]; then
      tmp="$(mktemp -d "${opensessionsDataDir}.tmp.XXXXXX")"
      cp -R "$src/." "$tmp/"
      chmod -R u+w "$tmp"
      if [[ -d "$target" ]]; then
        chmod -R u+w "$target" || true
        rm -rf "$target"
      fi
      mv "$tmp" "$target"
      printf '%s' "$version" > "$stamp"
    fi

    exec "$target/opensessions.tmux"
  '';
in
{
  programs.tmux = {
    enable = true;
    sensibleOnTop = true;
    baseIndex = 1;
    clock24 = true;
    escapeTime = 10;
    focusEvents = true;
    historyLimit = 100000;
    keyMode = "vi";
    mouse = true;
    newSession = true;
    terminal = "tmux-256color";
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavor 'mocha'
          set -g @catppuccin_status_background 'none'
          set -g @catppuccin_window_status_style 'none'
          set -g @catppuccin_pane_border_style 'fg=#{@thm_surface_0}'
          set -g @catppuccin_pane_active_border_style 'fg=#{@thm_mauve}'
          set -g @catppuccin_menu_selected_style 'fg=#{@thm_crust},bg=#{@thm_mauve}'
        '';
      }
      {
        plugin = pkgs.tmuxPlugins.prefix-highlight;
      }
      pkgs.tmuxPlugins.yank
      {
        plugin = pkgs.tmuxPlugins.resurrect;
        extraConfig = ''
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-strategy-nvim 'session'
        '';
      }
      {
        plugin = pkgs.tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '15'
        '';
      }
    ];
    extraConfig = ''
      set -g renumber-windows on
      set -g automatic-rename on
      set -g automatic-rename-format '#{pane_current_command}'
      set -g set-clipboard on
      set -g extended-keys on
      set -g extended-keys-format csi-u
      set -g @tmux-which-key-xdg-enable 1
      set -g @tmux-which-key-disable-autobuild 1
      set -g @opensessions-width '34'
      run-shell ${tmuxWhichKeyScript}
      run-shell ${opensessionsScript}
      set -g allow-passthrough on
      set -g mode-style 'fg=#{@thm_crust},bg=#{@thm_mauve},bold'
      set -g message-style 'fg=#{@thm_crust},bg=#{@thm_surface_1},bold'
      bind-key Space show-wk-menu-root
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      set -g status-position bottom
      set -g status-style 'bg=default'
      set -g window-status-separator ' '
      set -g status-left-length 16
      set -g status-right-length 140
      set -g status-left "#[fg=#{@thm_crust},bg=#{@thm_mauve},bold] #S #[default]"
      set -g window-status-format "#[fg=#{@thm_overlay_1}] #I #[fg=#{@thm_subtext_1}]#W #[default]"
      set -g window-status-current-format "#[fg=#{@thm_crust},bg=#{@thm_mauve},bold] #I #[fg=#{@thm_crust},bg=#{@thm_lavender},bold]#W #[default]"
      set -g status-right "#[fg=#{@thm_crust},bg=#{@thm_surface_0}] #{?pane_in_mode,COPY,#{prefix_highlight}} #[default]#[fg=#{@thm_crust},bg=#{@thm_rosewater}]#(if [ -n \"$SSH_CONNECTION\" ]; then printf ' %s ' \"$(hostname -s)\"; fi)#[default]#[fg=#{@thm_crust},bg=#{@thm_surface_1}] #{b:pane_current_path} #[default]#[fg=#{@thm_crust},bg=#{@thm_mauve}]#(branch=$(git -C \"#{pane_current_path}\" branch --show-current 2>/dev/null || git -C \"#{pane_current_path}\" rev-parse --short HEAD 2>/dev/null); [ -n \"$branch\" ] && printf ' %s ' \"$branch\")#[default]"
      set -g @prefix_highlight_fg '#{@thm_crust}'
      set -g @prefix_highlight_bg '#{@thm_mauve}'
      set -g @prefix_highlight_show_copy_mode 'on'
      set -g @prefix_highlight_copy_mode_attr 'fg=#{@thm_crust},bg=#{@thm_peach},bold'
      set -as terminal-features ',xterm*:RGB:clipboard:ccolour:cstyle:extkeys:focus:hyperlinks:mouse:osc7:sync:title'
      set -as terminal-overrides ',screen*:Ms=\E]52;%p1%s;%p2%s\007'
      set -as terminal-overrides ',tmux*:Ms=\E]52;%p1%s;%p2%s\007'
    '';
  };

  xdg.configFile."opensessions/config.json".text = builtins.toJSON {
    mux = "tmux";
    plugins = [ ];
    theme = {
      palette = {
        base = "#1e1e2e";
        mantle = "#1e1e2e";
        crust = "#1e1e2e";
        surface0 = "#313244";
        surface1 = "#45475a";
        surface2 = "#585b70";
        text = "#cdd6f4";
        subtext0 = "#a6adc8";
        subtext1 = "#bac2de";
        mauve = "#cba6f7";
        lavender = "#b4befe";
        teal = "#94e2d5";
        blue = "#89b4fa";
      };
    };
    sidebarWidth = 34;
    sidebarPosition = "right";
  };

  xdg.configFile."tmux/plugins/tmux-which-key/config.yaml".text = tmuxWhichKeyYaml;
  xdg.dataFile."tmux/plugins/tmux-which-key/init.tmux".source = tmuxWhichKeyInit;
}
