# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "ca/desrt/dconf-editor" = {
      saved-pathbar-path = "/apps/seahorse/windows/key-manager/";
      saved-view = "/";
      window-height = 500;
      window-is-maximized = false;
      window-width = 540;
    };

    "org/blueman/general" = {
      plugin-list = [ "NetUsage" ];
      window-properties = [ 500 350 710 435 ];
    };

    "org/blueman/plugins/autoconnect" = {
      services = [ (mkTuple [ "/org/bluez/hci0/dev_88_D0_39_97_7F_9F" "00000000-0000-0000-0000-000000000000" ]) ];
    };

    "org/blueman/plugins/powermanager" = {
      auto-power-on = "@mb true";
    };

    "org/gnome/Console" = {
      last-window-size = mkTuple [ 652 481 ];
    };

    "org/gnome/GWeather4" = {
      temperature-unit = "centigrade";
    };

    "org/gnome/Weather" = {
      locations = "[<(uint32 2, <('Cairo', 'HECA', true, [(0.52592587544986047, 0.54803338512621935)], [(0.52447144022429604, 0.54541539124822791)])>)>]";
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
      last-panel = "online-accounts";
      window-state = mkTuple [ 980 640 ];
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
      picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/fold-l.webp";
      picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/fold-d.webp";
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
      enable-hot-corners = false;
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
      application-children = [ "gnome-power-panel" "org-wezfurlong-wezterm" "spotify" "brave-browser" "org-telegram-desktop" "slack" ];
    };

    "org/gnome/desktop/notifications/application/bitwarden" = {
      application-id = "bitwarden.desktop";
    };

    "org/gnome/desktop/notifications/application/brave-browser" = {
      application-id = "brave-browser.desktop";
    };

    "org/gnome/desktop/notifications/application/gnome-power-panel" = {
      application-id = "gnome-power-panel.desktop";
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

    "org/gnome/desktop/peripherals/keyboard" = {
      delay = mkUint32 388;
      repeat-interval = mkUint32 21;
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
      picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/fold-l.webp";
      primary-color = "#26a269";
      secondary-color = "#000000";
    };

    "org/gnome/desktop/search-providers" = {
      disabled = [ ];
      sort-order = [ "org.gnome.Contacts.desktop" "org.gnome.Documents.desktop" "org.gnome.Settings.desktop" "org.gnome.Calculator.desktop" "org.gnome.Nautilus.desktop" "org.gnome.Calendar.desktop" "org.gnome.clocks.desktop" "org.gnome.seahorse.Application.desktop" "org.gnome.Photos.desktop" ];
    };

    "org/gnome/desktop/session" = {
      idle-delay = mkUint32 900;
    };

    "org/gnome/desktop/sound" = {
      event-sounds = true;
      theme-name = "__custom";
    };

    "org/gnome/desktop/wm/keybindings" = {
      move-to-workspace-1 = [ "<Alt><Super>1" ];
      move-to-workspace-2 = [ "<Alt><Super>2" ];
      move-to-workspace-3 = [ "<Alt><Super>3" ];
      move-to-workspace-4 = [ "<Alt><Super>4" ];
      move-to-workspace-left = [ "<Control><Super>Left" ];
      move-to-workspace-right = [ "<Control><Super>Right" ];
      switch-to-workspace-1 = [ "<Super>1" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
      toggle-fullscreen = [ "F11" ];
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
      num-workspaces = 4;
      titlebar-font = "Ubuntu Mono Bold 11";
    };

    "org/gnome/evolution-data-server" = {
      migrated = true;
    };

    "org/gnome/evolution-data-server/calendar" = {
      reminders-past = [ ];
    };

    "org/gnome/gnome-system-monitor" = {
      current-tab = "resources";
      maximized = false;
      network-total-in-bits = false;
      show-dependencies = false;
      show-whose-processes = "user";
      window-state = mkTuple [ 700 500 ];
    };

    "org/gnome/gnome-system-monitor/disktreenew" = {
      col-6-visible = true;
      col-6-width = 0;
    };

    "org/gnome/mutter" = {
      center-new-windows = true;
    };

    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "icon-view";
      migrated-gtk-settings = true;
      search-filter-time-type = "last_modified";
    };

    "org/gnome/nautilus/window-state" = {
      initial-size = mkTuple [ 838 652 ];
      maximized = false;
    };

    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = false;
      night-light-temperature = mkUint32 3907;
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/" ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>Return";
      command = "wezterm";
      name = "Terminal";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "<Shift><Super>b";
      command = "brave";
      name = "Browser";
    };

    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-timeout = 1800;
    };

    "org/gnome/shell" = {
      app-picker-layout = "[{'blueman-manager.desktop': <{'position': <0>}>, 'brave-browser.desktop': <{'position': <1>}>, 'org.gnome.Weather.desktop': <{'position': <2>}>, 'org.gnome.clocks.desktop': <{'position': <3>}>, 'org.gnome.Maps.desktop': <{'position': <4>}>, 'btop.desktop': <{'position': <5>}>, 'org.gnome.Photos.desktop': <{'position': <6>}>, 'org.gnome.Totem.desktop': <{'position': <7>}>, 'org.gnome.Calculator.desktop': <{'position': <8>}>, 'org.gnome.Calendar.desktop': <{'position': <9>}>, 'simple-scan.desktop': <{'position': <10>}>, 'org.gnome.Settings.desktop': <{'position': <11>}>, 'gnome-system-monitor.desktop': <{'position': <12>}>, 'ca.desrt.dconf-editor.desktop': <{'position': <13>}>, 'org.gnome.Extensions.desktop': <{'position': <14>}>, 'org.gnome.Nautilus.desktop': <{'position': <15>}>, 'cups.desktop': <{'position': <16>}>, 'nvim.desktop': <{'position': <17>}>, 'nixos-manual.desktop': <{'position': <18>}>, 'spotify.desktop': <{'position': <19>}>, 'org.gnome.font-viewer.desktop': <{'position': <20>}>, 'org.telegram.desktop.desktop': <{'position': <21>}>, 'org.gnome.TextEditor.desktop': <{'position': <22>}>, 'vlc.desktop': <{'position': <23>}>}, {'org.wezfurlong.wezterm.desktop': <{'position': <0>}>, 'xterm.desktop': <{'position': <1>}>, 'org.gnome.FileRoller.desktop': <{'position': <2>}>, 'org.gnome.Connections.desktop': <{'position': <3>}>, 'org.gnome.Console.desktop': <{'position': <4>}>, 'org.gnome.baobab.desktop': <{'position': <5>}>, 'org.gnome.DiskUtility.desktop': <{'position': <6>}>, 'org.gnome.Evince.desktop': <{'position': <7>}>, 'org.gnome.eog.desktop': <{'position': <8>}>, 'org.gnome.Logs.desktop': <{'position': <9>}>, 'org.gnome.seahorse.Application.desktop': <{'position': <10>}>, 'org.gnome.tweaks.desktop': <{'position': <11>}>}]";
      disable-user-extensions = false;
      disabled-extensions = [ "gsconnect@andyholmes.github.io" "space-bar@luchrioh" "workspace-indicator@gnome-shell-extensions.gcampax.github.com" "Vitals@CoreCoding.com" "user-theme@gnome-shell-extensions.gcampax.github.com" "auto-move-windows@gnome-shell-extensions.gcampax.github.com" "apps-menu@gnome-shell-extensions.gcampax.github.com" "places-menu@gnome-shell-extensions.gcampax.github.com" "window-list@gnome-shell-extensions.gcampax.github.com" ];
      enabled-extensions = [ "windowsNavigator@gnome-shell-extensions.gcampax.github.com" "drive-menu@gnome-shell-extensions.gcampax.github.com" "native-window-placement@gnome-shell-extensions.gcampax.github.com" "screenshot-window-sizer@gnome-shell-extensions.gcampax.github.com" "appindicatorsupport@rgcjonas.gmail.com" ];
      favorite-apps = [ ];
      last-selected-power-profile = "power-saver";
      welcome-dialog-last-shown-version = "44.0";
    };

    "org/gnome/shell/extensions/appindicator" = {
      custom-icons = "@a(sss) []";
      legacy-tray-enabled = true;
      tray-pos = "right";
    };

    "org/gnome/shell/extensions/auto-move-windows" = {
      application-list = [ ];
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

    "org/gnome/shell/extensions/trayIconsReloaded" = {
      applications = "[{\"id\":\"org.telegram.desktop.desktop\"},{\"id\":\"spotify.desktop\"},{\"id\":\"bitwarden.desktop\"}]";
      icon-size = 24;
      position-weight = 0;
      tray-position = "right";
    };

    "org/gnome/shell/extensions/user-theme" = {
      name = "Default";
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

    "org/gnome/shell/keybindings" = {
      switch-to-application-1 = [ ];
      switch-to-application-2 = [ ];
      switch-to-application-3 = [ ];
      switch-to-application-4 = [ ];
    };

    "org/gnome/shell/weather" = {
      automatic-location = true;
      locations = "[<(uint32 2, <('Cairo', 'HECA', true, [(0.52592587544986047, 0.54803338512621935)], [(0.52447144022429604, 0.54541539124822791)])>)>]";
    };

    "org/gnome/shell/world-clocks" = {
      locations = "@av []";
    };

    "org/gnome/tweaks" = {
      show-extensions-notice = false;
    };

    "org/gtk/gtk4/settings/file-chooser" = {
      date-format = "regular";
      location-mode = "path-bar";
      show-hidden = true;
      show-size-column = true;
      show-type-column = true;
      sidebar-width = 140;
      sort-column = "name";
      sort-directories-first = false;
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
      sidebar-width = 164;
      sort-column = "name";
      sort-directories-first = false;
      sort-order = "ascending";
      type-format = "category";
      window-position = mkTuple [ 102 102 ];
      window-size = mkTuple [ 1096 822 ];
    };

  };
}
