{
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    config = {
      warn_timeout = "5m";
      hide_env_diff = true;
      whitelist = {
        prefix = [
          "~/github/shekohex"
          "~/github/owlchat"
          "~/github/webb-tools"
        ];
      };
    };
    nix-direnv = {
      enable = true;
    };
  };
}
