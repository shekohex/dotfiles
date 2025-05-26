{ user, ... }:

{
  system = {
    primaryUser = user;
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
        _HIHideMenuBar = true;
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
        # I will disable hot corners for now.
        # since I'm going to use Aerospace window manager.

        # Hot corner action for top right corner.
        # wvous-tr-corner = 12; # Notification Center
        wvous-tr-corner = 1; # Disabled
        # Hot corner action for top left corner.
        # wvous-tl-corner = 3; # Application Windows
        wvous-tl-corner = 1; # Disabled
        # Hot corner action for bottom right corner.
        # wvous-br-corner = 3; # Desktop
        wvous-br-corner = 1; # Disabled
        # Hot corner action for bottom left corner.
        # wvous-bl-corner = 2; # Mission Control
        wvous-bl-corner = 1; # Disabled
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
    stateVersion = 5;
  };
}
