{ config, pkgs, ... }:

{
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.dotfiles/modules/programs/neovim/lazyvim";

  # Prebuilt rust backend; lazy.nvim uses it via `dir` (see plugins/fff.lua).
  xdg.dataFile."nvim/nix/fff.nvim".source = pkgs.vimPlugins.fff-nvim;

  home.packages = [
    pkgs.ripgrep
    pkgs.fd
    pkgs.fzf
    pkgs.lazygit
    pkgs.tree-sitter
    pkgs.gcc
    pkgs.lua-language-server
    pkgs.stylua
    pkgs.nil
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    sideloadInitLua = true;
    withRuby = false;
    withPython3 = false;
  };
}
