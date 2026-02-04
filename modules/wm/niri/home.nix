{
  config,
  pkgs,
  lib,
  ...
}:

let
  # Workspace definitions matching AeroSpace layout
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

  # Generate workspace keybindings
  workspaceBinds = builtins.concatStringsSep "\n" (
    builtins.concatLists (
      lib.mapAttrsToList (num: ws: [
        ''"Alt+${num}" { focus-workspace ${num}; }''
        ''"Alt+Shift+${num}" { move-window-to-workspace ${num}; }''
      ]) workspaces
    )
  );

  # Generate window rules
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
in
{
  # Write Niri config file - properly formatted KDL
  home.file.".config/niri/config.kdl".text = ''
    // Niri configuration
    // Workspaces: ${
      builtins.concatStringsSep ", " (lib.mapAttrsToList (n: v: "${n}:${v.name}") workspaces)
    }

    input {
        keyboard {
            xkb {
                layout "us"
            }
        }
        touchpad {
            tap
            natural-scroll
        }
    }

    output "eDP-1" {
        scale 1.0
    }

    layout {
        gaps 8
        center-focused-column "never"
    }

    spawn-at-startup "waybar"
    spawn-at-startup "mako"

    environment {
        QT_QPA_PLATFORMTHEME "gtk2"
        GTK_THEME "Adwaita-dark"
    }

    binds {
    ${workspaceBinds}

        // Focus navigation
        "Alt+H" { focus-column-left; }
        "Alt+J" { focus-window-down; }
        "Alt+K" { focus-window-up; }
        "Alt+L" { focus-column-right; }

        // Move window
        "Alt+Shift+H" { move-column-left; }
        "Alt+Shift+J" { move-window-down; }
        "Alt+Shift+K" { move-window-up; }
        "Alt+Shift+L" { move-column-right; }

        // Window actions
        "Alt+Q" { close-window; }
        "Alt+F" { maximize-column; }
        "Alt+Shift+F" { fullscreen-window; }

        // Layout actions
        "Alt+Comma" { consume-window-into-column; }
        "Alt+Period" { expel-window-from-column; }
        "Alt+R" { switch-preset-column-width; }
        "Alt+Shift+R" { switch-preset-window-height; }

        // Navigation
        "Alt+Tab" { focus-workspace-previous; }

        // Launchers
        "Alt+Space" { spawn "wofi" "--show" "drun"; }
        "Alt+Return" { spawn "ghostty"; }

        // Screenshot
        "Alt+Shift+S" { spawn "grim" "-g" "$(slurp)" "-" "|" "wl-copy"; }

        // Media keys
        "XF86AudioRaiseVolume" { spawn "pamixer" "-i" "5"; }
        "XF86AudioLowerVolume" { spawn "pamixer" "-d" "5"; }
        "XF86AudioMute" { spawn "pamixer" "-t"; }
        "XF86MonBrightnessUp" { spawn "brightnessctl" "set" "+5%"; }
        "XF86MonBrightnessDown" { spawn "brightnessctl" "set" "5%-"; }

        // Exit
        "Alt+Shift+E" { quit; }
    }

    ${windowRules}
  '';

  # Waybar configuration
  programs.waybar = {
    enable = true;
    systemd.enable = false;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        spacing = 4;
        modules-left = [
          "niri/workspaces"
          "niri/window"
        ];
        modules-center = [ "clock" ];
        modules-right = [
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          "disk"
          "battery"
          "tray"
        ];

        "niri/workspaces" = {
          format = "{name}";
          on-click = "activate";
        };

        "niri/window" = {
          max-length = 50;
        };

        clock = {
          format = "{:%Y-%m-%d %H:%M}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt>{calendar}";
          format-alt = "{:%H:%M}";
        };

        cpu = {
          format = " {usage}% ";
          tooltip = false;
        };

        memory = {
          format = " {}% ";
        };

        disk = {
          format = " {percentage_used}% ";
          path = "/";
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = " {capacity}% ";
          format-charging = " {capacity}% ";
          format-plugged = " {capacity}% ";
        };

        network = {
          format-wifi = " {essid} ({signalStrength}%) ";
          format-ethernet = " {ipaddr}/{cidr} ";
          tooltip-format = "{ifname} via {gwaddr}";
          format-linked = " {ifname} (No IP) ";
          format-disconnected = "Disconnected ";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };

        pulseaudio = {
          format = " {volume}% ";
          format-bluetooth = " {volume}% ";
          format-bluetooth-muted = " muted ";
          format-muted = " muted ";
          format-source = " {volume}% ";
          format-source-muted = "";
          on-click = "pamixer -t";
        };

        tray = {
          spacing = 10;
        };
      };
    };
    style = ''
      * {
        font-family: "Ubuntu", "Font Awesome 6 Free";
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background-color: #1e1e2e;
        color: #cdd6f4;
        border-bottom: 2px solid #313244;
      }

      #workspaces button {
        padding: 0 10px;
        color: #cdd6f4;
      }

      #workspaces button:hover {
        background-color: #313244;
      }

      #workspaces button.focused {
        background-color: #585b70;
      }

      #workspaces button.urgent {
        background-color: #f38ba8;
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #disk,
      #temperature,
      #backlight,
      #network,
      #pulseaudio,
      #tray {
        padding: 0 10px;
        margin: 0 4px;
        color: #cdd6f4;
      }

      #window {
        color: #cdd6f4;
      }
    '';
  };

  # Mako notification daemon
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

  # Wofi launcher
  programs.wofi = {
    enable = true;
    settings = {
      width = 600;
      height = 400;
      location = "center";
      show = "drun";
      prompt = "Search...";
      filter_rate = 100;
      allow_markup = true;
      no_actions = true;
      halign = "fill";
      orientation = "vertical";
      content_halign = "fill";
      insensitive = true;
      allow_images = true;
      image_size = 32;
      gtk_dark = true;
    };
    style = ''
      window {
        margin: 0px;
        border: 2px solid #313244;
        background-color: #1e1e2e;
        border-radius: 8px;
      }

      #input {
        margin: 5px;
        border: none;
        color: #cdd6f4;
        background-color: #313244;
        border-radius: 4px;
      }

      #inner-box {
        margin: 5px;
        border: none;
        background-color: #1e1e2e;
      }

      #outer-box {
        margin: 5px;
        border: none;
        background-color: #1e1e2e;
      }

      #scroll {
        margin: 0px;
        border: none;
      }

      #text {
        margin: 5px;
        border: none;
        color: #cdd6f4;
      }

      #entry:selected {
        background-color: #313244;
        border-radius: 4px;
      }

      #entry:selected #text {
        color: #cdd6f4;
      }
    '';
  };
}
