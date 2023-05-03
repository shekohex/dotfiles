# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/blueman/plugins/powermanager" = {
      auto-power-on = "@mb true";
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

    "org/gnome/control-center" = {
      last-panel = "info-overview";
      window-state = mkTuple [ 980 640 ];
    };

    "org/gnome/desktop/background" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-l.svg";
      picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-d.svg";
      primary-color = "#241f31";
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
      cursor-theme = "Catppuccin-Mocha-Teal-Cursors";
      enable-animations = true;
      enable-hot-corners = false;
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      font-name = "JetBrainsMono Medium";
      gtk-theme = "Catppuccin-Mocha-Standard-Teal-Dark";
      icon-theme = "Papirus";
      text-scaling-factor = 1.0;
      toolbar-style = "text";
    };

    "org/gnome/desktop/notifications" = {
      application-children = [ "gnome-power-panel" "org-wezfurlong-wezterm" ];
    };

    "org/gnome/desktop/notifications/application/gnome-power-panel" = {
      application-id = "gnome-power-panel.desktop";
    };

    "org/gnome/desktop/notifications/application/org-wezfurlong-wezterm" = {
      application-id = "org.wezfurlong.wezterm.desktop";
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/privacy" = {
      disable-camera = true;
      old-files-age = mkUint32 30;
      remove-old-temp-files = true;
      remove-old-trash-files = true;
      report-technical-problems = "false";
    };

    "org/gnome/desktop/screensaver" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-l.svg";
      primary-color = "#241f31";
      secondary-color = "#000000";
    };

    "org/gnome/desktop/search-providers" = {
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
      button-layout = "appmenu:close";
      num-workspaces = 6;
    };

    "org/gnome/gnome-system-monitor" = {
      maximized = false;
      network-total-in-bits = true;
      show-dependencies = false;
      show-whose-processes = "user";
    };

    "org/gnome/gnome-system-monitor/disktreenew" = {
      col-6-visible = true;
      col-6-width = 0;
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
      disable-user-extensions = false;
      disabled-extensions = [ "gsconnect@andyholmes.github.io" "space-bar@luchrioh" "places-menu@gnome-shell-extensions.gcampax.github.com" "window-list@gnome-shell-extensions.gcampax.github.com" "workspace-indicator@gnome-shell-extensions.gcampax.github.com" "apps-menu@gnome-shell-extensions.gcampax.github.com" ];
      enabled-extensions = [ "Vitals@CoreCoding.com" "user-theme@gnome-shell-extensions.gcampax.github.com" "windowsNavigator@gnome-shell-extensions.gcampax.github.com" "drive-menu@gnome-shell-extensions.gcampax.github.com" "native-window-placement@gnome-shell-extensions.gcampax.github.com" ];
      last-selected-power-profile = "power-saver";
      welcome-dialog-last-shown-version = "44.0";
    };

    "org/gnome/shell/extensions/auto-move-windows" = {
      application-list = [ "org.wezfurlong.wezterm.desktop:2" "brave-browser.desktop:1" "spotify.desktop:4" "org.telegram.desktop.desktop:3" ];
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

    "org/gnome/shell/extensions/user-theme" = {
      name = "Default";
    };

    "org/gnome/shell/extensions/vitals" = {
      alphabetize = true;
      hide-icons = false;
      hide-zeros = true;
      include-static-info = true;
      network-speed-format = 1;
      position-in-panel = 2;
      show-battery = false;
      show-system = true;
      use-higher-precision = true;
    };


    "org/gnome/tweaks" = {
      show-extensions-notice = false;
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
