{ pkgs, user, ... }:
let
  searchEngines = {
    "Startpage" = {
      # https://www.startpage.com/search/?q=%s
      urls = [{
        template = "https://www.startpage.com/search?q={searchTerms}";
      }];
      iconUpdateURL = "https://www.startpage.com/sp/cdn/favicons/favicon--default.ico";
      updateInterval = 24 * 60 * 60 * 1000; # every day
      definedAliases = [ "@sp" ];
    };
    "Nix Packages" = {
      urls = [{
        template = "https://search.nixos.org/packages";
        params = [
          { name = "type"; value = "packages"; }
          { name = "query"; value = "{searchTerms}"; }
        ];
      }];

      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = [ "@np" ];
    };

    "NixOS Wiki" = {
      urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
      iconUpdateURL = "https://nixos.wiki/favicon.png";
      updateInterval = 24 * 60 * 60 * 1000; # every day
      definedAliases = [ "@nw" ];
    };

    "Bing".metaData.hidden = true;
    "Google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
  };
  sharedExtensions = [ ];
in
{
  programs.firefox = {
    enable = true;
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
        extensions = sharedExtensions ++ [
          pkgs.nur.repos.rycee.firefox-addons.bitwarden
          pkgs.nur.repos.rycee.firefox-addons.sponsorblock
          pkgs.nur.repos.rycee.firefox-addons.refined-github
          pkgs.nur.repos.rycee.firefox-addons.ublock-origin
        ];
      };
      work = {
        id = 1;
        name = "Work";
        search = {
          engines = searchEngines;
          default = "Google";
          force = true;
          order = [
            "Google"
            "Startpage"
            "DuckDuckGo"
          ];
        };
        extensions = sharedExtensions ++ [
          pkgs.nur.repos.rycee.firefox-addons.metamask
          pkgs.nur.repos.rycee.firefox-addons.polkadot-js
        ];
        settings = {
          "browser.newtabpage.pinned" = [
            {
              title = "Notion";
              url = "https://www.notion.so/";
            }
            {
              title = "Google Meet";
              url = "https://meet.google.com/";
            }
            {
              title = "Google Calendar";
              url = "https://calendar.google.com/";
            }
          ];
        };
      };
    };
  };
}
