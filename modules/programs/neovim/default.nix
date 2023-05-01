{ pkgs, ... }:

{
  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      extraLuaPackages = luaPkgs: with luaPkgs; [ jsregexp ];
      extraLuaConfig = builtins.readFile ./config/init.lua;
      extraPackages =
        # Extra Packages to provided to neovim
        [ ] ++
        # LSP Servers
        [
          # Lua
          pkgs.lua-language-server
          pkgs.stylua
          # Nix
          pkgs.nil
          pkgs.nixpkgs-fmt
          # Nodejs
          pkgs.nodejs
          pkgs.nodePackages.prettier
          pkgs.nodePackages.vscode-langservers-extracted
        ];
      plugins =
        # UI and Colorscheme
        [
          {
            plugin = pkgs.vimExtraPlugins.catppuccin;
            type = "lua";
            config = builtins.readFile ./config/plugins/colorscheme.lua;
          }
          {
            plugin = pkgs.vimExtraPlugins.lualine-nvim;
            type = "lua";
            config = builtins.readFile ./config/plugins/lualine.lua;
          }
          pkgs.vimExtraPlugins.nvim-web-devicons
          {
            plugin = pkgs.pkgs.vimPlugins.dressing-nvim;
            type = "lua";
            config = builtins.readFile ./config/plugins/dressing.lua;
          }
          {
            plugin = pkgs.vimExtraPlugins.fidget-nvim;
            type = "lua";
            config = builtins.readFile ./config/plugins/fidget.lua;
          }
        ] ++
        # Performance
        [ pkgs.vimPlugins.impatient-nvim ] ++
        # LSP Config
        [
          pkgs.vimPlugins.lspkind-nvim
          pkgs.vimExtraPlugins.nvim-cmp
          pkgs.vimExtraPlugins.LuaSnip
          # Cmp Sources
          pkgs.vimExtraPlugins.cmp-nvim-lsp
          pkgs.vimExtraPlugins.cmp-buffer
          pkgs.vimExtraPlugins.cmp-emoji
          pkgs.vimExtraPlugins.cmp-nvim-lua
          pkgs.vimExtraPlugins.cmp-path
          # Copilot
          pkgs.vimPlugins.copilot-cmp
          {
            plugin = pkgs.vimPlugins.copilot-lua;
            type = "lua";
            config = builtins.readFile ./config/plugins/copilot.lua;
          }
          {
            plugin = pkgs.vimExtraPlugins.null-ls-nvim;
            type = "lua";
            config = builtins.readFile ./config/plugins/null_ls.lua;
          }
          # LSP
          {
            plugin = pkgs.vimPlugins.nvim-lspconfig;
            type = "lua";
            config = builtins.readFile ./config/plugins/lsp.lua;
          }
          pkgs.vimPlugins.neoconf-nvim
          pkgs.vimExtraPlugins.neodev-nvim
        ] ++
        # Treesitter
        [
          {
            plugin = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
            type = "lua";
            config = builtins.readFile ./config/plugins/treesitter.lua;
          }
          pkgs.vimPlugins.nvim-treesitter-context
          pkgs.vimPlugins.nvim-treesitter-textobjects
          pkgs.vimExtraPlugins.nvim-treesitter-textsubjects
        ] ++
        # Extra
        [
          pkgs.vimExtraPlugins.plenary-nvim
          {
            plugin = pkgs.vimExtraPlugins.telescope-nvim;
            type = "lua";
            config = builtins.readFile ./config/plugins/telescope.lua;
          }
        ];
    };
  };
}
