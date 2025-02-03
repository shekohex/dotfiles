{ user, ... }: {
  services.cloudflared = {
    enable = true;
    user = user;
    tunnels = {
      # workstation
      "a922f05b-61d5-4c3f-8c91-425bbff52c49" = {
        credentialsFile =
          "/home/${user}/.cloudflared/a922f05b-61d5-4c3f-8c91-425bbff52c49.json";
        default = "http_status:404";
      };
    };
  };
}
