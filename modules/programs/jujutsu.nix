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
        key = "F9F2447AD04C829791F1DE20987ED27840ED60F5";
      };
      git = {
        push-branch-prefix = "shady/";
      };
    };
  };
}
