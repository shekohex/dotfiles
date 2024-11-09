{ pkgs, ... }:

let
  apps = {
    ZenBrowser = {
      workspace = "workspace 1Browser";
      id = "org.mozilla.com.zen.browser";
    };
    ZedPreview = {
      workspace = "workspace 2Zed";
      id = "dev.zed.Zed-Preview";
    };
    Alacritty = {
      workspace = "workspace 3Alacritty";
      id = "org.alacritty";
    };
    Slack = {
      workspace = "workspace 4Slack";
      id = "com.slack.Slack";
    };
    Mail = {
      workspace = "workspace 5Mail";
      id = "ch.protonmail.desktop";
    };
    Spotify = {
      workspace = "workspace 6Spotify";
      id = "com.spotify.client";
    };
    Chats = {
      workspace = "workspace 7Chats";
      id = {
        Discord = "com.discordapp.Discord";
        Telegram = "ru.keepcoder.Telegram";
      };
    };
  };
in {
  services.aerospace = {
    enable = true;
    package = pkgs.aerospace;
    settings = {
      gaps = {
        outer.top = 8;
        outer.right = 8;
        outer.bottom = 8;
        outer.left = 8;
        inner.horizontal = 8;
        inner.vertical = 8;
      };
      key-mapping = { preset = "qwerty"; };
      mode.main.binding = {
        alt-1 = apps.ZenBrowser.workspace;
        alt-2 = apps.ZedPreview.workspace;
        alt-3 = apps.Alacritty.workspace;
        alt-4 = apps.Slack.workspace;
        alt-5 = apps.Mail.workspace;
        alt-6 = apps.Spotify.workspace;
        alt-7 = apps.Chats.workspace;
        alt-8 = "workspace 8";
        alt-9 = "workspace 9";

        alt-shift-1 = "move-node-to-${apps.ZenBrowser.workspace}";
        alt-shift-2 = "move-node-to-${apps.ZedPreview.workspace}";
        alt-shift-3 = "move-node-to-${apps.Alacritty.workspace}";
        alt-shift-4 = "move-node-to-${apps.Slack.workspace}";
        alt-shift-5 = "move-node-to-${apps.Mail.workspace}";
        alt-shift-6 = "move-node-to-${apps.Spotify.workspace}";
        alt-shift-7 = "move-node-to-${apps.Chats.workspace}";
        alt-shift-8 = "move-node-to-workspace 8";
        alt-shift-9 = "move-node-to-workspace 9";

        # See: https://nikitabobko.github.io/AeroSpace/commands#layout
        alt-slash = "layout tiles horizontal vertical";
        alt-comma = "layout accordion horizontal vertical";

        # See: https://nikitabobko.github.io/AeroSpace/commands#focus
        alt-h = "focus left";
        alt-j = "focus down";
        alt-k = "focus up";
        alt-l = "focus right";

        # See: https://nikitabobko.github.io/AeroSpace/commands#move
        alt-shift-h = "move left";
        alt-shift-j = "move down";
        alt-shift-k = "move up";
        alt-shift-l = "move right";

        # See: https://nikitabobko.github.io/AeroSpace/commands#resize
        alt-shift-minus = "resize smart -50";
        alt-shift-equal = "resize smart +50";

        # See: https://nikitabobko.github.io/AeroSpace/commands#workspace-back-and-forth
        alt-tab = "workspace-back-and-forth";

        # Switch to resize mode
        alt-r = "mode resize";
      };
      mode.resize.binding = {
        # Resize the window
        h = "resize width -50";
        j = "resize height +50";
        k = "resize height -50";
        l = "resize width +50";
        enter = "mode main";
        esc = "mode main";
      };
      # =================================================================
      #
      # Assign apps on particular workspaces
      #
      # Use this command to get IDs of running applications:
      #   aerospace list-apps
      #
      # =================================================================
      # Callbacks
      on-window-detected = [ ];
    };
  };
}
