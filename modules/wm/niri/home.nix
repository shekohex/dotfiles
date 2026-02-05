{
  config,
  pkgs,
  lib,
  ...
}:

let
  workspaces = {
    "1" = {
      name = "Browser";
      apps = [
        "zen-browser"
        "^zen.*"
      ];
    };
    "2" = {
      name = "Code";
      apps = [
        "code"
        "code-.*"
        "zed"
        "jetbrains-.*"
      ];
    };
    "3" = {
      name = "Terminal";
      apps = [
        "com.mitchellh.ghostty"
        "org.alacritty"
        ".*terminal.*"
      ];
    };
    "4" = {
      name = "Slack";
      apps = [ "slack" ];
    };
    "5" = {
      name = "Mail";
      apps = [
        "proton-mail"
        "ch.protonmail.desktop"
      ];
    };
    "6" = {
      name = "Spotify";
      apps = [ "spotify" ];
    };
    "7" = {
      name = "Chats";
      apps = [
        "discord"
        "telegram-desktop"
      ];
    };
    "8" = {
      name = "Misc";
      apps = [ "com.debank.RabbyDesktop" ];
    };
    "9" = {
      name = "Notes";
      apps = [
        "obsidian"
        "md.obsidian"
      ];
    };
  };

  workspaceBinds = builtins.concatStringsSep "\n" (
    builtins.concatLists (
      lib.mapAttrsToList (num: ws: [
        ''"Alt+${num}" { focus-workspace ${num}; }''
        ''"Alt+Shift+${num}" { move-window-to-workspace ${num}; }''
      ]) workspaces
    )
  );

  windowRules = builtins.concatStringsSep "\n" (
    builtins.concatLists (
      lib.mapAttrsToList (
        num: ws:
        map (app: ''
          window-rule {
              match app-id="${app}"
              open-on-workspace "${num}"
          }'') ws.apps
      ) workspaces
    )
  );

  baseConfig = ''
    input {
        keyboard {
            xkb {
                layout "us"
            }
            repeat-delay 200
            repeat-rate 50
        }
        touchpad {
            tap
            natural-scroll
        }
    }

    output "eDP-1" {
        scale 1.0
    }

    prefer-no-csd

    window-rule {
        geometry-corner-radius 12
        clip-to-geometry true
    }

    window-rule {
        draw-border-with-background false
    }

    window-rule {
        match app-id="com.mitchellh.ghostty"
        border {
            off
        }
        focus-ring {
            off
        }
    }

    spawn-at-startup "sh" "-c" "eww daemon --restart; sleep 0.3; eww open bar"
    spawn-at-startup "mako"

    binds {
    ${workspaceBinds}

        // Show hotkey overlay
        "Alt+Shift+Slash" { show-hotkey-overlay; }

        // Navigation (vim-style)
        "Alt+H" { focus-column-left; }
        "Alt+J" { focus-window-down; }
        "Alt+K" { focus-window-up; }
        "Alt+L" { focus-column-right; }

        // Move windows
        "Alt+Shift+H" { move-column-left; }
        "Alt+Shift+J" { move-window-down; }
        "Alt+Shift+K" { move-window-up; }
        "Alt+Shift+L" { move-column-right; }

        // Window management
        "Alt+Q" { close-window; }
        "Alt+F" { maximize-column; }
        "Alt+Shift+F" { fullscreen-window; }
        "Alt+M" { maximize-window-to-edges; }

        // Column management
        "Alt+Comma" { consume-window-into-column; }
        "Alt+Period" { expel-window-from-column; }
        "Alt+BracketLeft" { consume-or-expel-window-left; }
        "Alt+BracketRight" { consume-or-expel-window-right; }
        "Alt+R" { switch-preset-column-width; }
        "Alt+Shift+R" { switch-preset-window-height; }
        "Alt+Ctrl+R" { reset-window-height; }
        "Alt+C" { center-column; }
        "Alt+Ctrl+C" { center-visible-columns; }
        "Alt+Ctrl+F" { expand-column-to-available-width; }

        // Column/window sizing
        "Alt+Minus" { set-column-width "-10%"; }
        "Alt+Equal" { set-column-width "+10%"; }
        "Alt+Shift+Minus" { set-window-height "-10%"; }
        "Alt+Shift+Equal" { set-window-height "+10%"; }

        // Floating & tabs
        "Alt+V" { toggle-window-floating; }
        "Alt+Shift+V" { switch-focus-between-floating-and-tiling; }
        "Alt+W" { toggle-column-tabbed-display; }

        // Overview
        "Alt+O" { toggle-overview; }

        // Workspace navigation
        "Alt+Tab" { focus-workspace-previous; }
        "Alt+U" { focus-workspace-down; }
        "Alt+I" { focus-workspace-up; }
        "Alt+Page_Down" { focus-workspace-down; }
        "Alt+Page_Up" { focus-workspace-up; }

        // Move column to workspace
        "Alt+Ctrl+U" { move-column-to-workspace-down; }
        "Alt+Ctrl+I" { move-column-to-workspace-up; }
        "Alt+Ctrl+Page_Down" { move-column-to-workspace-down; }
        "Alt+Ctrl+Page_Up" { move-column-to-workspace-up; }

        // Move workspace
        "Alt+Shift+U" { move-workspace-down; }
        "Alt+Shift+I" { move-workspace-up; }
        "Alt+Shift+Page_Down" { move-workspace-down; }
        "Alt+Shift+Page_Up" { move-workspace-up; }

        // Mouse wheel workspace switching
        "Alt+WheelScrollDown" cooldown-ms=150 { focus-workspace-down; }
        "Alt+WheelScrollUp" cooldown-ms=150 { focus-workspace-up; }
        "Alt+Ctrl+WheelScrollDown" cooldown-ms=150 { move-column-to-workspace-down; }
        "Alt+Ctrl+WheelScrollUp" cooldown-ms=150 { move-column-to-workspace-up; }
        "Alt+WheelScrollRight" { focus-column-right; }
        "Alt+WheelScrollLeft" { focus-column-left; }
        "Alt+Ctrl+WheelScrollRight" { move-column-right; }
        "Alt+Ctrl+WheelScrollLeft" { move-column-left; }
        "Alt+Shift+WheelScrollDown" { focus-column-right; }
        "Alt+Shift+WheelScrollUp" { focus-column-left; }
        "Alt+Ctrl+Shift+WheelScrollDown" { move-column-right; }
        "Alt+Ctrl+Shift+WheelScrollUp" { move-column-left; }

        // Monitor navigation
        "Alt+Shift+Left" { focus-monitor-left; }
        "Alt+Shift+Down" { focus-monitor-down; }
        "Alt+Shift+Up" { focus-monitor-up; }
        "Alt+Shift+Right" { focus-monitor-right; }

        // Move column to monitor
        "Alt+Shift+Ctrl+Left" { move-column-to-monitor-left; }
        "Alt+Shift+Ctrl+Down" { move-column-to-monitor-down; }
        "Alt+Shift+Ctrl+Up" { move-column-to-monitor-up; }
        "Alt+Shift+Ctrl+Right" { move-column-to-monitor-right; }

        // Launchers
        "Alt+Space" { spawn "fuzzel"; }
        "Alt+Return" { spawn "ghostty"; }

        // Screenshots
        "Alt+Shift+S" { spawn "grim" "-g" "$(slurp)" "-" "|" "wl-copy"; }
        "Print" { screenshot; }
        "Ctrl+Print" { screenshot-screen; }
        "Alt+Print" { screenshot-window; }

        // Media keys
        "XF86AudioRaiseVolume" { spawn "pamixer" "-i" "5"; }
        "XF86AudioLowerVolume" { spawn "pamixer" "-d" "5"; }
        "XF86AudioMute" { spawn "pamixer" "-t"; }
        "XF86MonBrightnessUp" { spawn "brightnessctl" "set" "+5%"; }
        "XF86MonBrightnessDown" { spawn "brightnessctl" "set" "5%-"; }

        // System
        "Alt+Shift+E" { quit; }
        "Alt+Shift+P" { power-off-monitors; }
        "Alt+Escape" allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }
    }

    ${windowRules}
  '';

  catppuccinMocha = ''
    layout {
        background-color "#1e1e2e"
        struts {
            top 5
        }

        focus-ring {
            off
            width 2
            active-color "#cba6f7"
            inactive-color "#45475a"
            urgent-color "#f38ba8"
        }

        border {
            on
            width 2
            active-color "#cba6f7"
            inactive-color "#313244"
            urgent-color "#f38ba8"
            active-gradient from="#f5c2e7" to="#cba6f7" angle=45 relative-to="workspace-view"
        }

        shadow {
            on
            softness 30
            spread 4
            offset x=0 y=6
            color "#11111b66"
            inactive-color "#11111b33"
        }

        insert-hint {
            color "#cba6f766"
        }

        tab-indicator {
            hide-when-single-tab
            place-within-column
            gap 6
            width 4
            length total-proportion=1.0
            position "right"
            gaps-between-tabs 2
            corner-radius 8
            active-color "#cba6f7"
            inactive-color "#45475a"
            urgent-color "#f38ba8"
        }
    }

    overview {
        backdrop-color "#1e1e2e"
    }
  '';

  catppuccinMacchiato = ''
    layout {
        background-color "#24273a"
        struts {
            top 5
        }

        focus-ring {
            off
            width 2
            active-color "#c6a0f6"
            inactive-color "#494d64"
            urgent-color "#ed8796"
        }

        border {
            on
            width 2
            active-color "#c6a0f6"
            inactive-color "#363a4f"
            urgent-color "#ed8796"
            active-gradient from="#f5bde6" to="#c6a0f6" angle=45 relative-to="workspace-view"
        }

        shadow {
            on
            softness 30
            spread 4
            offset x=0 y=6
            color "#18192666"
            inactive-color "#18192633"
        }

        insert-hint {
            color "#c6a0f666"
        }

        tab-indicator {
            hide-when-single-tab
            place-within-column
            gap 6
            width 4
            length total-proportion=1.0
            position "right"
            gaps-between-tabs 2
            corner-radius 8
            active-color "#c6a0f6"
            inactive-color "#494d64"
            urgent-color "#ed8796"
        }
    }

    overview {
        backdrop-color "#24273a"
    }
  '';

  catppuccinFrappe = ''
    layout {
        background-color "#303446"
        struts {
            top 5
        }

        focus-ring {
            off
            width 2
            active-color "#ca9ee6"
            inactive-color "#51576d"
            urgent-color "#e78284"
        }

        border {
            on
            width 2
            active-color "#ca9ee6"
            inactive-color "#414559"
            urgent-color "#e78284"
            active-gradient from="#f4b8e4" to="#ca9ee6" angle=45 relative-to="workspace-view"
        }

        shadow {
            on
            softness 30
            spread 4
            offset x=0 y=6
            color "#23263466"
            inactive-color "#23263433"
        }

        insert-hint {
            color "#ca9ee666"
        }

        tab-indicator {
            hide-when-single-tab
            place-within-column
            gap 6
            width 4
            length total-proportion=1.0
            position "right"
            gaps-between-tabs 2
            corner-radius 8
            active-color "#ca9ee6"
            inactive-color "#51576d"
            urgent-color "#e78284"
        }
    }

    overview {
        backdrop-color "#303446"
    }
  '';

  catppuccinLatte = ''
    layout {
        background-color "#eff1f5"
        struts {
            top 5
        }

        focus-ring {
            off
            width 2
            active-color "#8839ef"
            inactive-color "#bcc0cc"
            urgent-color "#d20f39"
        }

        border {
            on
            width 2
            active-color "#8839ef"
            inactive-color "#ccd0da"
            urgent-color "#d20f39"
            active-gradient from="#ea76cb" to="#8839ef" angle=45 relative-to="workspace-view"
        }

        shadow {
            on
            softness 30
            spread 4
            offset x=0 y=6
            color "#4c4f6940"
            inactive-color "#4c4f6926"
        }

        insert-hint {
            color "#8839ef4d"
        }

        tab-indicator {
            hide-when-single-tab
            place-within-column
            gap 6
            width 4
            length total-proportion=1.0
            position "right"
            gaps-between-tabs 2
            corner-radius 8
            active-color "#8839ef"
            inactive-color "#bcc0cc"
            urgent-color "#d20f39"
        }
    }

    overview {
        backdrop-color "#eff1f5"
    }
  '';
in
{
  home.file.".config/niri/config.kdl".text = ''
    include "${config.home.homeDirectory}/.config/niri/config.d/base.kdl"
    include "${config.home.homeDirectory}/.local/state/niri/theme.kdl"
  '';

  home.file.".config/niri/config.d/base.kdl".text = baseConfig;

  home.file.".config/niri/themes/catppuccin-mocha.kdl".text = catppuccinMocha;
  home.file.".config/niri/themes/catppuccin-macchiato.kdl".text = catppuccinMacchiato;
  home.file.".config/niri/themes/catppuccin-frappe.kdl".text = catppuccinFrappe;
  home.file.".config/niri/themes/catppuccin-latte.kdl".text = catppuccinLatte;

  home.file.".config/eww/eww.yuck".text = ''
    (defpoll workspaces :interval "1s" "~/.config/eww/scripts/niri-workspaces")
    (defpoll focused_window :interval "1s" "~/.config/eww/scripts/niri-focused-window")
    (defpoll time :interval "1s" "date +\"%a %b %d  %H:%M\"")

    (defwidget workspaces []
      (label :class "workspaces" :text workspaces))

    (defwidget window-title []
      (label :class "window-title" :text focused_window))

    (defwidget clock []
      (label :class "clock" :text time))

    (defwidget bar []
      (box :class "bar"
        (box :class "bar-left" :halign "start" :hexpand true
          (workspaces))
        (box :class "bar-center" :halign "center" :hexpand true
          (window-title))
        (box :class "bar-right" :halign "end" :hexpand true
          (clock))))

    (defwindow bar
      :monitor 0
      :geometry (geometry :x "0" :y "0" :width "100%" :height "60px" :anchor "top center")
      :stacking "fg"
      :exclusive true
      (bar))
  '';

  home.file.".config/eww/eww.scss".text = ''
    * {
      all: unset;
      font-family: "JetBrainsMono Nerd Font", "Font Awesome 6 Free";
      font-size: 12px;
      font-weight: 500;
      color: #cdd6f4;
    }

    .bar {
      background: linear-gradient(135deg, rgba(24, 24, 37, 0.92), rgba(30, 30, 46, 0.86));
      border: 1px solid rgba(69, 71, 90, 0.9);
      border-radius: 14px;
      padding: 8px 14px;
      margin: 6px 12px;
      box-shadow: 0 8px 22px rgba(17, 17, 27, 0.55);
    }

    .workspaces {
      background: rgba(30, 30, 46, 0.7);
      border: 1px solid rgba(69, 71, 90, 0.8);
      border-radius: 10px;
      padding: 4px 10px;
      letter-spacing: 0.2px;
      color: #cdd6f4;
    }

    .window-title {
      font-size: 12px;
      color: #bac2de;
      padding: 0 10px;
    }

    .clock {
      background: rgba(49, 50, 68, 0.6);
      border: 1px solid rgba(120, 123, 149, 0.5);
      border-radius: 10px;
      padding: 4px 12px;
      color: #cdd6f4;
    }
  '';

  home.file.".config/eww/scripts/niri-workspaces" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      set -eu
      niri msg -j workspaces | jq -r 'if type == "array" then . else .workspaces end | map((if (.focused // .is_focused // false) then "● " elif (.visible // .is_visible // false) then "○ " else "· " end) + (.name // (.id|tostring))) | join("  ")'
    '';
  };

  home.file.".config/eww/scripts/niri-focused-window" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      set -eu
      niri msg -j focused-window | jq -r 'if . == null then "" else (.title // .app_id // "") end'
    '';
  };

  home.activation.niriThemeSeed = {
    after = [ "writeBoundary" ];
    before = [ ];
    data = ''
      theme_state_dir="${config.home.homeDirectory}/.local/state/niri"
      theme_state_file="$theme_state_dir/theme.kdl"
      if [ ! -f "$theme_state_file" ]; then
        mkdir -p "$theme_state_dir"
        cp "${config.home.homeDirectory}/.config/niri/themes/catppuccin-mocha.kdl" "$theme_state_file"
      fi
    '';
  };

  home.packages = [
    pkgs.eww
    pkgs.fuzzel
    pkgs.jq
    pkgs.swww
    pkgs.matugen
    pkgs.catppuccin-gtk
    pkgs.catppuccin-cursors
    pkgs.papirus-icon-theme
    (pkgs.writeShellScriptBin "niri-ctp-theme" ''
      set -eu
      flavor="${"$"}{1:-mocha}"
      src="${"$"}HOME/.config/niri/themes/catppuccin-${"$"}flavor.kdl"
      dst_dir="${"$"}HOME/.local/state/niri"
      dst="${"$"}dst_dir/theme.kdl"
      if [ ! -f "${"$"}src" ]; then
        echo "unknown flavor: ${"$"}flavor" >&2
        exit 2
      fi
      mkdir -p "${"$"}dst_dir"
      cp -f "${"$"}src" "${"$"}dst"
      if command -v niri >/dev/null 2>&1; then
        niri validate >/dev/null 2>&1 || true
      fi
    '')
  ];

  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Standard-Mauve-Dark";
      package = pkgs.catppuccin-gtk;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  home.pointerCursor = {
    name = "Catppuccin-Mocha-Dark-Cursors";
    package = pkgs.catppuccin-cursors;
    size = 24;
    x11 = {
      enable = true;
      defaultCursor = "Catppuccin-Mocha-Dark-Cursors";
    };
  };

  home.sessionVariables = {
    GTK_THEME = "Catppuccin-Mocha-Standard-Mauve-Dark";
    XCURSOR_THEME = "Catppuccin-Mocha-Dark-Cursors";
    XCURSOR_SIZE = "24";
  };

  services.mako = {
    enable = true;
    settings = {
      background-color = "#1e1e2e";
      text-color = "#cdd6f4";
      border-color = "#313244";
      border-size = 2;
      border-radius = 8;
      padding = "10";
      margin = "10";
      default-timeout = 5000;
    };
  };
}
