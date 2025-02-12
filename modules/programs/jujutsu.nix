{
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "Shady Khalifa";
        email = "dev+github@shadykhalifa.me";
      };
      ui = {
        diff = {
          tool = [
            "difft"
            "--color=always"
            "$left"
            "$right"
          ];
        };
        editor = "nvim";
      };
      aliases = { };
      signing = {
        sign-all = true;
        key = "280AC7E475B1C3C74233C3FF52DFAC81BEA54EAA";
      };
      git = {
        push-branch-prefix = "shady/";
      };
    };
  };
}
