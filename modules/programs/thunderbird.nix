{ ... }:

{
  programs.thunderbird = {
    enable = true;
    profiles = {
      shekohex = {
        isDefault = true;
      };
    };
    settings = { "privacy.donottrackheader.enabled" = true; };
  };
}
