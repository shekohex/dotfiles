{ pkgs, ... }:
let
  sessionWizardBin = "${pkgs.tmuxPlugins.session-wizard}/share/tmux-plugins/session-wizard/bin/t";

  tmuxWhichKeyScript = pkgs.writeShellScript "tmux-which-key-init.sh" ''
    set -euo pipefail
    export PATH="${pkgs.coreutils}/bin:$PATH"
    exec "${pkgs.tmuxPlugins.tmux-which-key.rtp}"
  '';

  tmuxWhichKeyYaml = builtins.readFile ./tmux-which-key.yaml;

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
      sensible
      better-mouse-mode
      session-wizard
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
          set -g @continuum-save-interval '1'
          set -g @continuum-boot 'on'
        '';
      }
    ];
    extraConfig = ''
      set -g status on
      set -g status-interval 5
      set -g renumber-windows on
      set -g automatic-rename on
      set -g automatic-rename-format '#{?pane_title,#{pane_title},#{pane_current_command}}'
      set -g allow-rename on
      set -g set-titles on
      set -g set-titles-string '#{?pane_title,#{pane_title},#{pane_current_command}}'
      set -g set-clipboard on
      set -g extended-keys on
      set -g extended-keys-format csi-u
      set -g @tmux-which-key-xdg-enable 1
      set -g @tmux-which-key-disable-autobuild 1
      set -g @session-wizard-height 40
      set -g @session-wizard-width 80
      run-shell ${tmuxWhichKeyScript}
      set -g allow-passthrough on
      set -g mode-style 'fg=#{@thm_crust},bg=#{@thm_mauve},bold'
      set -g message-style 'fg=#{@thm_crust},bg=#{@thm_surface_1},bold'
      set -g pane-border-style 'fg=#{@thm_surface_0}'
      set -g pane-active-border-style 'fg=#{@thm_mauve}'
      set -g pane-border-format '#{?pane_active,#[reverse],}#{pane_index}#[default] #{?#{<=:#{pane_width},40},#{=/12/…:pane_title},#{=/32/…:pane_title}}'
      bind-key Space show-wk-menu-root
      bind-key C-s run-shell "${pkgs.tmuxPlugins.resurrect}/share/tmux-plugins/resurrect/scripts/save.sh"
      bind-key C-r run-shell "${pkgs.tmuxPlugins.resurrect}/share/tmux-plugins/resurrect/scripts/restore.sh"
      bind-key C-w run-shell "${sessionWizardBin}"
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      bind-key -T copy-mode-vi Enter send-keys -X copy-selection-and-cancel
      bind-key -T copy-mode MouseDragEnd1Pane send-keys -X copy-selection-and-cancel
      bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-selection-and-cancel
      set -g status-position bottom
      set -g status-style 'bg=default'
      set -g window-status-separator '  '
      set -g status-left-length 16
      set -g status-right-length 0
      set -g status-left '#[fg=#{@thm_crust},bg=#{@thm_mauve},bold] #S #[default] '
      set -g window-status-format '#[fg=#{@thm_overlay_1}] #{?#{<=:#{client_width},60},#I:#{=/12/…:#{?pane_title,#{pane_title},#W}},#I #{=/40/…:#{?pane_title,#{pane_title},#W}}} #[default]'
      set -g window-status-current-format '#[fg=#{@thm_crust},bg=#{@thm_mauve},bold] #{?#{<=:#{client_width},60},#I:#{=/12/…:#{?pane_title,#{pane_title},#W}},#I #{=/40/…:#{?pane_title,#{pane_title},#W}}} #[default]'
      set -g status-right ""
      set -g @prefix_highlight_fg '#{@thm_crust}'
      set -g @prefix_highlight_bg '#{@thm_mauve}'
      set -g @prefix_highlight_show_copy_mode 'on'
      set -g @prefix_highlight_copy_mode_attr 'fg=#{@thm_crust},bg=#{@thm_peach},bold'
      set -g @scroll-speed-num-lines-per-scroll '1'
      set -g @scroll-down-exit-copy-mode 'on'
      set -as terminal-features ',xterm*:RGB:clipboard:ccolour:cstyle:extkeys:focus:hyperlinks:mouse:osc7:sync:title'
      set -as terminal-features ',linux*:RGB:clipboard:ccolour:cstyle:extkeys:focus:hyperlinks:mouse:osc7:sync:title'
      set -as terminal-features ',termux*:RGB:clipboard:ccolour:cstyle:extkeys:focus:hyperlinks:mouse:osc7:sync:title'
      set -as terminal-overrides ',screen*:Ms=\E]52;%p1%s;%p2%s\007'
      set -as terminal-overrides ',tmux*:Ms=\E]52;%p1%s;%p2%s\007'
      set -as terminal-overrides ',xterm*:sitm=\E[3m:ritm=\E[23m'
      set -as terminal-overrides ',linux*:sitm=\E[3m:ritm=\E[23m'
      set -as terminal-overrides ',termux*:sitm=\E[3m:ritm=\E[23m'
    '';
  };

  xdg.configFile."tmux/plugins/tmux-which-key/config.yaml".text = tmuxWhichKeyYaml;
  xdg.dataFile."tmux/plugins/tmux-which-key/init.tmux".source = tmuxWhichKeyInit;
}
