# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "apps/seahorse/listing" = {
      keyrings-selected = [ "pkcs11:model=p11-kit-trust;manufacturer=PKCS%2311%20Kit;serial=1;token=System%20Trust" ];
    };

    "apps/seahorse/windows/key-manager" = {
      height = 654;
      width = 1092;
    };

    "org/blueman/general" = {
      show-statusbar = false;
      window-properties = [ 500 350 710 547 ];
    };

    "org/blueman/network" = {
      nap-enable = false;
    };

    "org/blueman/plugins/powermanager" = {
      auto-power-on = true;
    };

    "org/freedesktop/tracker/miner/files" = {
      index-recursive-directories = [ "&DESKTOP" "&DOCUMENTS" "&MUSIC" "&PICTURES" "&VIDEOS" "/home/shady/Downloads" ];
    };

    "org/gnome/Console" = {
      last-window-size = mkTuple [ 652 481 ];
    };

    "org/gnome/GWeather4" = {
      temperature-unit = "centigrade";
    };

    "org/gnome/baobab/ui" = {
      is-maximized = false;
      window-size = mkTuple [ 960 600 ];
    };

    "org/gnome/calculator" = {
      accuracy = 9;
      angle-units = "degrees";
      base = 10;
      button-mode = "basic";
      number-format = "automatic";
      show-thousands = false;
      show-zeroes = false;
      source-currency = "";
      source-units = "degree";
      target-currency = "";
      target-units = "radian";
      window-maximized = false;
      window-size = mkTuple [ 360 485 ];
      word-size = 64;
    };

    "org/gnome/calendar" = {
      active-view = "month";
      window-maximized = false;
      window-size = mkTuple [ 768 600 ];
    };

    "org/gnome/clocks/state/window" = {
      maximized = false;
      panel-id = "world";
      size = mkTuple [ 870 690 ];
    };

    "org/gnome/control-center" = {
      last-panel = "background";
      window-state = mkTuple [ 980 640 false ];
    };

    "org/gnome/desktop/a11y/keyboard" = {
      bouncekeys-beep-reject = true;
      bouncekeys-enable = false;
    };

    "org/gnome/desktop/app-folders" = {
      folder-children = [ "Utilities" "YaST" ];
    };

    "org/gnome/desktop/app-folders/folders/Utilities" = {
      apps = [ "gnome-abrt.desktop" "gnome-system-log.desktop" "nm-connection-editor.desktop" "org.gnome.baobab.desktop" "org.gnome.Connections.desktop" "org.gnome.DejaDup.desktop" "org.gnome.Dictionary.desktop" "org.gnome.DiskUtility.desktop" "org.gnome.eog.desktop" "org.gnome.Evince.desktop" "org.gnome.FileRoller.desktop" "org.gnome.fonts.desktop" "org.gnome.seahorse.Application.desktop" "org.gnome.tweaks.desktop" "org.gnome.Usage.desktop" "vinagre.desktop" ];
      categories = [ "X-GNOME-Utilities" ];
      name = "X-GNOME-Utilities.directory";
      translate = true;
    };

    "org/gnome/desktop/app-folders/folders/YaST" = {
      categories = [ "X-SuSE-YaST" ];
      name = "suse-yast.directory";
      translate = true;
    };

    "org/gnome/desktop/background" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/ring-l.jxl";
      picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/ring-d.jxl";
      primary-color = "#26a269";
      secondary-color = "#000000";
    };

    "org/gnome/desktop/input-sources" = {
      sources = [ (mkTuple [ "xkb" "us" ]) (mkTuple [ "xkb" "ara" ]) ];
      xkb-options = [ "terminate:ctrl_alt_bksp" ];
    };

    "org/gnome/desktop/interface" = {
      clock-show-date = true;
      clock-show-weekday = true;
      color-scheme = "prefer-dark";
      cursor-size = 24;
      cursor-theme = "Adwaita";
      document-font-name = "Ubuntu 11";
      enable-animations = true;
      enable-hot-corners = true;
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      font-name = "Ubuntu 10";
      gtk-theme = "Adwaita";
      icon-theme = "Papirus";
      monospace-font-name = "JetBrainsMonoNL Nerd Font Mono 10";
      text-scaling-factor = 1.0;
      toolbar-style = "text";
    };

    "org/gnome/desktop/notifications" = {
      application-children = [ "gnome-power-panel" "org-wezfurlong-wezterm" "spotify" "org-telegram-desktop" "slack" "org-gnome-evolution-alarm-notify" "discord" "firefox" ];
      show-banners = true;
      show-in-lock-screen = true;
    };

    "org/gnome/desktop/notifications/application/bitwarden" = {
      application-id = "bitwarden.desktop";
    };

    "org/gnome/desktop/notifications/application/blueman-manager" = {
      application-id = "blueman-manager.desktop";
      enable = true;
    };

    "org/gnome/desktop/notifications/application/discord" = {
      application-id = "discord.desktop";
    };

    "org/gnome/desktop/notifications/application/firefox" = {
      application-id = "firefox.desktop";
    };

    "org/gnome/desktop/notifications/application/frame" = {
      application-id = "frame.desktop";
    };

    "org/gnome/desktop/notifications/application/gnome-network-panel" = {
      application-id = "gnome-network-panel.desktop";
    };

    "org/gnome/desktop/notifications/application/gnome-power-panel" = {
      application-id = "gnome-power-panel.desktop";
    };

    "org/gnome/desktop/notifications/application/motrix" = {
      application-id = "motrix.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-baobab" = {
      application-id = "org.gnome.baobab.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-evolution-alarm-notify" = {
      application-id = "org.gnome.Evolution-alarm-notify.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-nautilus" = {
      application-id = "org.gnome.Nautilus.desktop";
    };

    "org/gnome/desktop/notifications/application/org-telegram-desktop" = {
      application-id = "org.telegram.desktop.desktop";
      force-expanded = true;
    };

    "org/gnome/desktop/notifications/application/org-wezfurlong-wezterm" = {
      application-id = "org.wezfurlong.wezterm.desktop";
      force-expanded = true;
    };

    "org/gnome/desktop/notifications/application/slack" = {
      application-id = "slack.desktop";
    };

    "org/gnome/desktop/notifications/application/spotify" = {
      application-id = "spotify.desktop";
      details-in-lock-screen = true;
      enable = true;
      force-expanded = true;
    };

    "org/gnome/desktop/notifications/application/thunderbird" = {
      application-id = "thunderbird.desktop";
    };

    "org/gnome/desktop/peripherals/keyboard" = {
      delay = mkUint32 250;
      repeat-interval = mkUint32 24;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/privacy" = {
      disable-camera = true;
      old-files-age = mkUint32 30;
      recent-files-max-age = -1;
      remove-old-temp-files = true;
      remove-old-trash-files = true;
      report-technical-problems = "false";
    };

    "org/gnome/desktop/screensaver" = {
      color-shading-type = "solid";
      lock-delay = mkUint32 30;
      picture-options = "zoom";
      picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/ring-l.jxl";
      primary-color = "#26a269";
      secondary-color = "#000000";
    };

    "org/gnome/desktop/search-providers" = {
      disabled = [ ];
      sort-order = [ "org.gnome.Contacts.desktop" "org.gnome.Documents.desktop" "org.gnome.Settings.desktop" "org.gnome.Calculator.desktop" "org.gnome.Nautilus.desktop" "org.gnome.Calendar.desktop" "org.gnome.clocks.desktop" "org.gnome.seahorse.Application.desktop" "org.gnome.Photos.desktop" ];
    };

    "org/gnome/desktop/session" = {
      idle-delay = mkUint32 600;
    };

    "org/gnome/desktop/sound" = {
      event-sounds = true;
      theme-name = "__custom";
    };

    "org/gnome/shell/keybindings" = {
      switch-to-application-1 = [];
      switch-to-application-2 = [];
      switch-to-application-3 = [];
      switch-to-application-4 = [];
      switch-to-application-5 = [];
      switch-to-application-6 = [];
      switch-to-application-7 = [];
      switch-to-application-8 = [];
      switch-to-application-9 = [];
    };

    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>q" ];
      move-to-workspace-1 = [ "<Alt><Super>1" ];
      move-to-workspace-2 = [ "<Alt><Super>2" ];
      move-to-workspace-3 = [ "<Alt><Super>3" ];
      move-to-workspace-4 = [ "<Alt><Super>4" ];
      move-to-workspace-5 = [ "<Alt><Super>5" ];
      move-to-workspace-6 = [ "<Alt><Super>6" ];
      move-to-workspace-7 = [ "<Alt><Super>7" ];
      move-to-workspace-8 = [ "<Alt><Super>8" ];
      move-to-workspace-9 = [ "<Alt><Super>9" ];
      move-to-workspace-left = [ "<Control><Super>Left" ];
      move-to-workspace-right = [ "<Control><Super>Right" ];
      switch-to-workspace-1 = [ "<Super>1" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
      switch-to-workspace-5 = [ "<Super>5" ];
      switch-to-workspace-6 = [ "<Super>6" ];
      switch-to-workspace-7 = [ "<Super>7" ];
      switch-to-workspace-8 = [ "<Super>8" ];
      switch-to-workspace-9 = [ "<Super>9" ];
      toggle-fullscreen = [ "F11" ];
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
      num-workspaces = 9;
      resize-with-right-button = true;
      titlebar-font = "Ubuntu Mono Bold 11";
    };

    "org/gnome/evince/default" = {
      window-ratio = mkTuple [ 0.979832 0.75772 ];
    };

    "org/gnome/evolution-data-server" = {
      migrated = true;
    };

    "org/gnome/evolution-data-server/calendar" = {
      notify-window-height = 489;
      notify-window-paned-position = 50;
      notify-window-width = 766;
      notify-window-x = 610;
      notify-window-y = 342;
      reminders-past = [ ];
    };

    "org/gnome/file-roller/dialogs/extract" = {
      recreate-folders = true;
      skip-newer = false;
    };

    "org/gnome/file-roller/listing" = {
      list-mode = "as-folder";
      name-column-width = 250;
      show-path = false;
      sort-method = "name";
      sort-type = "ascending";
    };

    "org/gnome/file-roller/ui" = {
      sidebar-width = 200;
      window-height = 480;
      window-width = 600;
    };

    "org/gnome/gnome-system-monitor" = {
      cpu-colors = [ (mkTuple [ (mkUint32 0) "#e6194B" ]) (mkTuple [ 1 "#f58231" ]) (mkTuple [ 2 "#ffe119" ]) (mkTuple [ 3 "#bfef45" ]) (mkTuple [ 4 "#3cb44b" ]) (mkTuple [ 5 "#42d4f4" ]) (mkTuple [ 6 "#4363d8" ]) (mkTuple [ 7 "#911eb4" ]) (mkTuple [ 8 "#f032e6" ]) (mkTuple [ 9 "#fabebe" ]) (mkTuple [ 10 "#ffd8b1" ]) (mkTuple [ 11 "#fffac8" ]) (mkTuple [ 12 "#aaffc3" ]) (mkTuple [ 13 "#469990" ]) (mkTuple [ 14 "#000075" ]) (mkTuple [ 15 "#e6beff" ]) (mkTuple [ 16 "#7f7df3327999" ]) (mkTuple [ 17 "#f3327999a2f9" ]) (mkTuple [ 18 "#7999c674f332" ]) (mkTuple [ 19 "#e9f0f3327999" ]) (mkTuple [ 20 "#d8f97999f332" ]) (mkTuple [ 21 "#7999f332b57d" ]) (mkTuple [ 22 "#f33292027999" ]) (mkTuple [ 23 "#799984abf332" ]) (mkTuple [ 24 "#a826f3327999" ]) (mkTuple [ 25 "#f3327999cba1" ]) (mkTuple [ 26 "#7999ef1df332" ]) (mkTuple [ 27 "#f332d3cb7999" ]) (mkTuple [ 28 "#b0507999f332" ]) (mkTuple [ 29 "#7999f3328cd5" ]) (mkTuple [ 30 "#f332799989d8" ]) (mkTuple [ 31 "#7999ad53f332" ]) ];
      cpu-stacked-area-chart = false;
      current-tab = "resources";
      maximized = false;
      network-total-in-bits = false;
      show-dependencies = false;
      show-whose-processes = "user";
      update-interval = 2000;
      window-state = mkTuple [ 700 500 ];
    };

    "org/gnome/gnome-system-monitor/disktreenew" = {
      col-0-visible = true;
      col-0-width = 140;
      col-6-visible = true;
      col-6-width = 0;
    };

    "org/gnome/gnome-system-monitor/proctree" = {
      col-18-visible = false;
      col-18-width = 0;
      col-2-visible = true;
      col-2-width = 0;
    };

    "org/gnome/mutter" = {
      center-new-windows = true;
      edge-tiling = false;
      overlay-key = "Super_L";
    };

    "org/gnome/nautilus/icon-view" = {
      captions = [ "type" "starred" "none" ];
    };

    "org/gnome/nautilus/list-view" = {
      use-tree-view = false;
    };

    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "icon-view";
      migrated-gtk-settings = true;
      search-filter-time-type = "last_modified";
      search-view = "list-view";
    };

    "org/gnome/nautilus/window-state" = {
      initial-size = mkTuple [ 890 550 ];
      maximized = false;
    };

    "org/gnome/nm-applet/eap/20a34c65-12e9-451d-a78b-9d4eba11b5ad" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/nm-applet/eap/6f576a38-0d0a-3f72-b0cd-2477351cfae9" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/nm-applet/eap/7f53421a-0995-4eb4-844e-d5b7fa6a20f9" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = false;
      night-light-temperature = mkUint32 3907;
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      control-center = [ "<Super>period" ];
      custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" ];
      home = [ "<Shift><Super>f" ];
      www = [ "<Shift><Super>b" ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>Return";
      command = "alacritty";
      name = "Terminal";
    };

    "org/gnome/settings-daemon/plugins/power" = {
      power-button-action = "nothing";
      sleep-inactive-ac-timeout = 0;
      sleep-inactive-ac-type = "nothing";
    };

    "org/gnome/shell" = {
      disable-user-extensions = false;
      disabled-extensions = [ "gsconnect@andyholmes.github.io" "space-bar@luchrioh" "Vitals@CoreCoding.com" "auto-move-windows@gnome-shell-extensions.gcampax.github.com" "window-list@gnome-shell-extensions.gcampax.github.com" "Hide_Activities@shay.shayel.org" "places-menu@gnome-shell-extensions.gcampax.github.com" "workspace-indicator@gnome-shell-extensions.gcampax.github.com" "apps-menu@gnome-shell-extensions.gcampax.github.com" "system-monitor@gnome-shell-extensions.gcampax.github.com" "user-theme@gnome-shell-extensions.gcampax.github.com" ];
      enabled-extensions = [ "windowsNavigator@gnome-shell-extensions.gcampax.github.com" "drive-menu@gnome-shell-extensions.gcampax.github.com" "native-window-placement@gnome-shell-extensions.gcampax.github.com" "screenshot-window-sizer@gnome-shell-extensions.gcampax.github.com" "appindicatorsupport@rgcjonas.gmail.com" "search-light@icedman.github.com" "blur-my-shell@aunetx" "just-perfection-desktop@just-perfection" ];
      favorite-apps = [ ];
      welcome-dialog-last-shown-version = "44.0";
    };

    "org/gnome/shell/extensions/appindicator" = {
      custom-icons = "@a(sss) []";
      legacy-tray-enabled = false;
      tray-pos = "right";
    };

    "org/gnome/shell/extensions/auto-move-windows" = {
      application-list = [ ];
    };

    "org/gnome/shell/extensions/blur-my-shell" = {
      brightness = 0.38;
      settings-version = 2;
      sigma = 30;
    };

    "org/gnome/shell/extensions/blur-my-shell/appfolder" = {
      brightness = 0.38;
      customize = false;
      sigma = 30;
    };

    "org/gnome/shell/extensions/blur-my-shell/applications" = {
      blur-on-overview = true;
      brightness = 0.9;
    };

    "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
      blur = true;
      brightness = 0.38;
      sigma = 30;
      static-blur = true;
      style-dash-to-dock = 0;
    };

    "org/gnome/shell/extensions/blur-my-shell/hidetopbar" = {
      compatibility = false;
    };

    "org/gnome/shell/extensions/blur-my-shell/overview" = {
      style-components = 3;
    };

    "org/gnome/shell/extensions/blur-my-shell/panel" = {
      blur = true;
      brightness = 0.58;
      color = mkTuple [ 0.0 0.0 ];
      customize = false;
      noise-lightness = 0.0;
      override-background = true;
      override-background-dynamically = true;
      sigma = 113;
      static-blur = true;
      style-panel = 0;
      unblur-in-overview = false;
    };

    "org/gnome/shell/extensions/blur-my-shell/window-list" = {
      brightness = 0.38;
      customize = false;
      sigma = 30;
    };

    "org/gnome/shell/extensions/caffeine" = {
      indicator-position-max = 1;
    };

    "org/gnome/shell/extensions/dash-to-panel" = {
      available-monitors = [ 0 ];
      primary-monitor = 0;
    };

    "org/gnome/shell/extensions/forge" = {
      css-last-update = mkUint32 37;
    };

    "org/gnome/shell/extensions/just-perfection" = {
      accessibility-menu = false;
      activities-button = false;
      activities-button-icon-monochrome = true;
      animation = 1;
      app-menu = true;
      app-menu-icon = true;
      app-menu-label = false;
      background-menu = true;
      calendar = false;
      clock-menu = true;
      clock-menu-position = 0;
      clock-menu-position-offset = 0;
      controls-manager-spacing-size = 0;
      dash = false;
      dash-app-running = false;
      dash-icon-size = 16;
      dash-separator = false;
      double-super-to-appgrid = true;
      events-button = true;
      gesture = true;
      hot-corner = false;
      keyboard-layout = true;
      notification-banner-position = 2;
      osd = true;
      panel = true;
      panel-arrow = true;
      panel-corner-size = 0;
      panel-in-overview = true;
      panel-notification-icon = true;
      power-icon = false;
      quick-settings = true;
      ripple-box = false;
      search = true;
      show-apps-button = false;
      startup-status = 0;
      theme = true;
      top-panel-position = 0;
      weather = false;
      window-demands-attention-focus = true;
      window-maximized-on-create = true;
      window-picker-icon = false;
      window-preview-caption = true;
      window-preview-close-button = true;
      workspace = true;
      workspace-background-corner-size = 0;
      workspace-popup = false;
      workspace-switcher-should-show = false;
      workspaces-in-app-grid = false;
      world-clock = false;
    };

    "org/gnome/shell/extensions/search-light" = {
      background-color = mkTuple [ 0.0 0.0 ];
      blur-background = true;
      blur-brightness = 0.26;
      blur-sigma = 22.0;
      border-color = mkTuple [ 0.0 0.0 ];
      border-radius = 1.105263;
      border-thickness = 1;
      entry-font-size = 1;
      monitor-count = 1;
      popup-at-cursor-monitor = true;
      scale-height = 0.1;
      scale-width = 0.28;
      shortcut-search = [ "<Super>slash" ];
      show-panel-icon = false;
    };

    "org/gnome/shell/extensions/trayIconsReloaded" = {
      applications = "[{\"id\":\"org.telegram.desktop.desktop\"},{\"id\":\"spotify.desktop\"},{\"id\":\"bitwarden.desktop\"}]";
      icon-size = 24;
      position-weight = 0;
      tray-position = "right";
    };

    "org/gnome/shell/extensions/user-theme" = {
      name = "";
    };

    "org/gnome/shell/extensions/vitals" = {
      alphabetize = true;
      fixed-widths = true;
      hide-icons = false;
      hide-zeros = true;
      hot-sensors = [ "_processor_usage_" "_memory_usage_" "__network-rx_max__" "__network-tx_max__" "__temperature_avg__" ];
      include-static-info = false;
      network-speed-format = 1;
      position-in-panel = 2;
      show-battery = false;
      show-processor = true;
      show-system = true;
      show-temperature = true;
      update-time = 5;
      use-higher-precision = true;
    };

    "org/gnome/shell/world-clocks" = {
      locations = [ ];
    };

    "org/gnome/simple-scan" = {
      document-type = "photo";
    };

    "org/gnome/tweaks" = {
      show-extensions-notice = false;
    };

    "org/gtk/gtk4/settings/color-chooser" = {
      custom-colors = [ (mkTuple [ 0.0 0.0 ]) (mkTuple [ 0.141176 0.141176 ]) (mkTuple [ 0.141176 0.141176 ]) (mkTuple [ 0.141176 0.141176 ]) (mkTuple [ 0.141176 0.141176 ]) (mkTuple [ 0.0 0.0 ]) ];
      selected-color = mkTuple [ true 0.0 ];
    };

    "org/gtk/gtk4/settings/file-chooser" = {
      date-format = "regular";
      location-mode = "path-bar";
      show-hidden = true;
      show-size-column = true;
      show-type-column = true;
      sidebar-width = 140;
      sort-column = "name";
      sort-directories-first = true;
      sort-order = "ascending";
      type-format = "category";
      view-type = "list";
      window-size = mkTuple [ 811 374 ];
    };

    "org/gtk/settings/file-chooser" = {
      date-format = "regular";
      location-mode = "path-bar";
      show-hidden = true;
      show-size-column = true;
      show-type-column = true;
      sidebar-width = 176;
      sort-column = "name";
      sort-directories-first = false;
      sort-order = "ascending";
      type-format = "category";
      window-position = mkTuple [ 495 130 ];
      window-size = mkTuple [ 1096 822 ];
    };

    "system/proxy" = {
      mode = "none";
    };

    "system/proxy/socks" = {
      host = "127.0.0.1";
      port = 9050;
    };

  };
}
