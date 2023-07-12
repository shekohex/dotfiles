{
  system = {
    defaults = {
      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
        AppleInterfaceStyleSwitchesAutomatically = false;
        AppleICUForce24HourTime = true;
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        InitialKeyRepeat = 15;
        KeyRepeat = 2;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSDocumentSaveNewDocumentsToCloud = false;
        NSTableViewDefaultSizeMode = 2;
      };

      dock = {
        autohide = true;
        orientation = "bottom";
        showhidden = true;
        tilesize = 40;
        minimize-to-application = true;
        mru-spaces = false;
        show-recents = false;
        static-only = true;
        # Hot corner action for top right corner.
        wvous-tr-corner = 12; # Notification Center
        # Hot corner action for top left corner.
        wvous-tl-corner = 3; # Application Windows
        # Hot corner action for bottom right corner.
        wvous-br-corner = 3; # Desktop
        # Hot corner action for bottom left corner.
        wvous-bl-corner = 2; # Mission Control
      };

      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        QuitMenuItem = false;
        CreateDesktop = false;
      };
      trackpad = {
        Clicking = true;
        TrackpadRightClick = true;
        Dragging = true;
      };
      loginwindow = {
        GuestEnabled = false;
      };
    };
    stateVersion = 4;
  };
}
