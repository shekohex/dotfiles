{ pkgs, user, ... }:
let
  searchEngines = {
    "Startpage" = {
      # https://www.startpage.com/search/?q=%s
      urls = [ { template = "https://www.startpage.com/search?q={searchTerms}"; } ];
      iconUpdateURL = "https://www.startpage.com/sp/cdn/favicons/favicon--default.ico";
      updateInterval = 24 * 60 * 60 * 1000; # every day
      definedAliases = [ "@sp" ];
    };
    "Nix Packages" = {
      urls = [
        {
          template = "https://search.nixos.org/packages";
          params = [
            {
              name = "type";
              value = "packages";
            }
            {
              name = "query";
              value = "{searchTerms}";
            }
          ];
        }
      ];

      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = [ "@np" ];
    };

    "NixOS Wiki" = {
      urls = [ { template = "https://nixos.wiki/index.php?search={searchTerms}"; } ];
      iconUpdateURL = "https://nixos.wiki/favicon.png";
      updateInterval = 24 * 60 * 60 * 1000; # every day
      definedAliases = [ "@nw" ];
    };

    "Bing".metaData.hidden = true;
    "Google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
  };
  preferences = {
    "browser.toolbars.bookmarks.visibility" = "never";
    "browser.fullscreen.autohide" = false;
    "media.ffmpeg.vaapi.enabled" = true;
    "media.hardware-video-decoding.force-enabled" = true;
    "general.smoothScroll.msdPhysics.enabled" = true;
    "layout.frame_rate" = 75;
    "layout.css.backdrop-filter.enabled" = true;
    # "layout.css.devPixelsPerPx" = "1.2";
    "layout.css.devPixelsPerPx" = "-1.0";
    "devtools.debugger.remote-enabled" = true;
    "devtools.chrome.enabled" = true;
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    "browser.newtabpage.enabled" = false;
    # Arkenfox stuff
    # https://github.com/arkenfox/user.js/wiki/
    "browser.aboutConfig.showWarning" = false;
    "browser.shell.checkDefaultBrowser" = false;
    "browser.startup.page" = 1;
    "browser.newtabpage.activity-stream.showSponsored" = false;
    "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
    "browser.newtabpage.activity-stream.default.sites" = "";
    "geo.provider.use_corelocation" = false;
    "geo.provider.use_gpsd" = false;
    "geo.provider.use_geoclue" = false;
    "geo.enabled" = false;
    "browser.region.network.url" = "";
    "browser.region.update.enabled" = false;
    "intl.accept_languages" = "en-US, en";
    "javascript.use_us_english_locale" = true;
    "extensions.getAddons.showPane" = false;
    "extensions.htmlaboutaddons.recommendations.enabled" = false;
    "browser.discovery.enabled" = false;
    "datareporting.policy.dataSubmissionEnabled" = false;
    "datareporting.healthreport.uploadEnabled" = false;
    "toolkit.telemetry.unified" = false;
    "toolkit.telemetry.enabled" = false;
    "toolkit.telemetry.server" = "data: =";
    "toolkit.telemetry.archive.enabled" = false;
    "toolkit.telemetry.newProfilePing.enabled" = false;
    "toolkit.telemetry.shutdownPingSender.enabled" = false;
    "toolkit.telemetry.updatePing.enabled" = false;
    "toolkit.telemetry.bhrPing.enabled" = false;
    "toolkit.telemetry.firstShutdownPing.enabled" = false;
    "toolkit.telemetry.coverage.opt-out" = true;
    "toolkit.coverage.opt-out" = true;
    "toolkit.coverage.endpoint.base" = "";
    "browser.ping-centre.telemetry" = false;
    "browser.newtabpage.activity-stream.feeds.telemetry" = false;
    "browser.newtabpage.activity-stream.telemetry" = false;
    "app.shield.optoutstudies.enabled" = false;
    "app.normandy.enabled" = false;
    "app.normandy.api_url" = "";
    "breakpad.reportURL" = "";
    "browser.tabs.crashReporting.sendReport" = false;
    "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
    "captivedetect.canonicalURL" = "";
    "network.captive-portal-service.enabled" = false;
    "network.connectivity-service.enabled" = false;
    "browser.safebrowsing.downloads.remote.enabled" = false;
    "network.prefetch-next" = false;
    "network.dns.disablePrefetch" = true;
    "network.predictor.enabled" = false;
    "network.predictor.enable-prefetch" = false;
    "network.http.speculative-parallel-limit" = 0;
    "browser.places.speculativeConnect.enabled" = false;
    "network.dns.disableIPv6" = true;
    "network.proxy.socks_remote_dns" = true;
    "network.file.disable_unc_paths" = true;
    "network.gio.supported-protocols" = "";
    "keyword.enabled" = true;
    "browser.fixup.alternate.enabled" = false;
    "browser.search.suggest.enabled" = false;
    "browser.urlbar.suggest.searches" = false;
    "browser.urlbar.speculativeConnect.enabled" = false;
    "browser.urlbar.dnsResolveSingleWordsAfterSearch" = 0;
    "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
    "browser.urlbar.suggest.quicksuggest.sponsored" = false;
    "browser.formfill.enable" = false;
    "signon.autofillForms" = false;
    "signon.formlessCapture.enabled" = false;
    "network.auth.subresource-http-auth-allow" = 1;
    "browser.cache.disk.enable" = false;
    "browser.privatebrowsing.forceMediaMemoryCache" = true;
    "media.memory_cache_max_size" = 65536;
    "browser.sessionstore.privacy_level" = 2;
    "toolkit.winRegisterApplicationRestart" = false;
    "browser.shell.shortcutFavicons" = false;
    "security.ssl.require_safe_negotiation" = false;
    "security.tls.enable_0rtt_data" = false;
    "security.OCSP.enabled" = 1;
    "security.OCSP.require" = false;
    "security.family_safety.mode" = 0;
    "security.cert_pinning.enforcement_level" = 2;
    "security.remote_settings.crlite_filters.enabled" = true;
    "security.pki.crlite_mode" = 2;
    "security.mixed_content.block_display_content" = true;
    "dom.security.https_only_mode" = true;
    "dom.security.https_only_mode_send_http_background_request" = false;
    "security.ssl.treat_unsafe_negotiation_as_broken" = true;
    "browser.ssl_override_behavior" = 1;
    "browser.xul.error_pages.expert_bad_cert" = true;
    "network.http.referer.XOriginPolicy" = 0;
    "network.http.referer.XOriginTrimmingPolicy" = 2;
    "privacy.userContext.enabled" = true;
    "privacy.userContext.ui.enabled" = true;
    "media.peerconnection.ice.proxy_only_if_behind_proxy" = true;
    "media.peerconnection.ice.default_address_only" = true;
    "media.eme.enabled" = true;
    "dom.disable_beforeunload" = true;
    "dom.disable_window_move_resize" = true;
    "dom.disable_open_during_load" = true;
    "dom.popup_allowed_events" = "click dblclick mousedown pointerdown";
    "accessibility.force_disabled" = 1;
    "beacon.enabled" = false;
    "browser.helperApps.deleteTempFileOnExit" = true;
    "browser.pagethumbnails.capturing_disabled" = true;
    "browser.uitour.enabled" = false;
    "browser.uitour.url" = "";
    "middlemouse.contentLoadURL" = false;
    "permissions.manager.defaultsUrl" = "";
    "webchannel.allowObject.urlWhitelist" = "";
    "network.IDN_show_punycode" = true;
    "pdfjs.disabled" = false;
    "pdfjs.enableScripting" = false;
    "network.protocol-handler.external.ms-windows-store" = false;
    "permissions.delegation.enabled" = false;
    "browser.download.useDownloadDir" = true;
    "browser.download.alwaysOpenPanel" = false;
    "browser.download.manager.addToRecentDocs" = false;
    "browser.download.always_ask_before_handling_new_types" = true;
    "extensions.enabledScopes" = 5;
    "extensions.autoDisableScopes" = 15;
    "extensions.postDownloadThirdPartyPrompt" = false;
    "browser.contentblocking.category" = "strict";
    "privacy.partition.serviceWorkers" = true;
    "privacy.partition.always_partition_third_party_non_cookie_storage" = true;
    "privacy.partition.always_partition_third_party_non_cookie_storage.exempt_sessionstorage" = false;
    "privacy.sanitize.sanitizeOnShutdown" = true;
    "privacy.clearOnShutdown.cache" = false;
    "privacy.clearOnShutdown.downloads" = false;
    "privacy.clearOnShutdown.formdata" = true;
    "privacy.clearOnShutdown.history" = false;
    "privacy.clearOnShutdown.sessions" = false;
    "privacy.clearOnShutdown.cookies" = false;
    "privacy.clearOnShutdown.offlineApps" = true;
    "privacy.cpd.cache" = true;
    "privacy.cpd.formdata" = true;
    "privacy.cpd.history" = true;
    "privacy.cpd.sessions" = true;
    "privacy.cpd.offlineApps" = false;
    "privacy.cpd.cookies" = false;
    "privacy.sanitize.timeSpan" = 0;
    "privacy.resistFingerprinting" = false;
    "privacy.window.maxInnerWidth" = 2294;
    "privacy.window.maxInnerHeight" = 1490;
    "privacy.resistFingerprinting.block_mozAddonManager" = false;
    "privacy.resistFingerprinting.letterboxing" = false;
    "browser.startup.blankWindow" = false;
    "browser.display.use_system_colors" = false;
    "widget.non-native-theme.enabled" = true;
    "browser.link.open_newwindow" = 3;
    "browser.link.open_newwindow.restriction" = 0;
    "webgl.disabled" = false;
    "extensions.blocklist.enabled" = true;
    "network.http.referer.spoofSource" = false;
    "security.dialog_enable_delay" = 1000;
    "privacy.firstparty.isolate" = false;
    "extensions.webcompat.enable_shims" = true;
    "security.tls.version.enable-deprecated" = false;
    "extensions.webcompat-reporter.enabled" = false;
    "browser.startup.homepage_override.mstone" = "ignore";
    "browser.messaging-system.whatsNewPanel.enabled" = false;
    "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
    "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
    "browser.urlbar.suggest.quicksuggest" = false;
    "app.update.background.scheduling.enabled" = false;
    "security.csp.enable" = true;
    "security.ask_for_password" = 2;
    "security.password_lifetime" = 5;
    "dom.storage.next_gen" = true;
    "network.cookie.lifetimePolicy" = 0;
    "security.pki.sha1_enforcement_level" = 1;
  };
  wrappedFirefox = pkgs.wrapFirefox pkgs.firefox-beta-unwrapped {
    extraPolicies = {
      CaptivePortal = false;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DisableFirefoxAccounts = false;
      DisableFormHistory = true;
      DisplayBookmarksToolbar = true;
      DontCheckDefaultBrowser = true;
      FirefoxHome = {
        Pocket = false;
        Snippets = false;
      };
      PasswordManagerEnabled = false;
      PromptForDownloadLocation = true;
      UserMessaging = {
        ExtensionRecommendations = false;
        SkipOnboarding = true;
      };
      ExtensionSettings = {
        "ebay@search.mozilla.org".installation_mode = "blocked";
        "amazondotcom@search.mozilla.org".installation_mode = "blocked";
        "bing@search.mozilla.org".installation_mode = "blocked";
        "ddg@search.mozilla.org".installation_mode = "blocked";
        "wikipedia@search.mozilla.org".installation_mode = "blocked";
      };
      Preferences = preferences;
    };
  };
  package = if pkgs.stdenv.isDarwin then pkgs.firefox-beta-bin else wrappedFirefox;
in
{
  programs.firefox = {
    inherit package;
    enable = false;
    profiles = {
      ${user} = {
        id = 0;
        name = "Default";
        search = {
          engines = searchEngines;
          default = "Startpage";
          force = true;
          order = [
            "Startpage"
            "DuckDuckGo"
            "Google"
          ];
        };
        extensions = [
          pkgs.nur.repos.rycee.firefox-addons.bitwarden
          pkgs.nur.repos.rycee.firefox-addons.sponsorblock
          pkgs.nur.repos.rycee.firefox-addons.refined-github
          pkgs.nur.repos.rycee.firefox-addons.ublock-origin
          pkgs.nur.repos.rycee.firefox-addons.multi-account-containers
          # For Work
          pkgs.nur.repos.rycee.firefox-addons.metamask
          pkgs.nur.repos.rycee.firefox-addons.polkadot-js
        ];
        settings = preferences;
      };
    };
  };
}
