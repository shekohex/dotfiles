{
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      auto_sync = true;
      update_check = false;
      search_mode = "fuzzy";
      keymap_mode = "vim-normal";
    };
    flags = [ "--disable-up-arrow" ];
  };
}
