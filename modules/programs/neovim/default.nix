{ pkgs, ... }:

{
  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      extraLuaPackages = luaPkgs: with luaPkgs; [ jsregexp ];
      extraPython3Packages =
        pythonPkgs: with pythonPkgs; [
          pynvim
          beancount
        ];
      extraLuaConfig = builtins.readFile ./config/init.lua;
      # These are going to be only available for Neovim, not golbaly
      extraPackages =
        # Extra Packages to provided to neovim
        [
          pkgs.ripgrep
          pkgs.fd
        ]
        ++
        # LSP Servers
        [
          # Lua
          pkgs.lua-language-server
          pkgs.stylua
          # Nix
          pkgs.nil
          # Nodejs (required for Copilot)
          pkgs.nodejs
          # For Jsonls
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
          {
            plugin = pkgs.vimPlugins.mini-nvim;
            type = "lua";
            config = builtins.readFile ./config/plugins/mini.lua;
          }
          {
            plugin = pkgs.vimExtraPlugins.gitsigns-nvim;
            type = "lua";
            config = builtins.readFile ./config/plugins/gitsigns.lua;
          }
        ]
        ++
          # Performance
          [ pkgs.vimPlugins.impatient-nvim ]
        ++
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
            pkgs.vimPlugins.cmp-beancount
            # Copilot
            pkgs.vimPlugins.copilot-cmp
            {
              plugin = pkgs.vimPlugins.copilot-lua;
              type = "lua";
              config = builtins.readFile ./config/plugins/copilot.lua;
            }
            {
              plugin = pkgs.vimPlugins.none-ls-nvim;
              type = "lua";
              config = builtins.readFile ./config/plugins/none_ls.lua;
            }
            # LSP
            {
              plugin = pkgs.vimPlugins.nvim-lspconfig;
              type = "lua";
              config = builtins.readFile ./config/plugins/lsp.lua;
            }
            # Lua Stuff
            pkgs.vimExtraPlugins.neodev-nvim
            pkgs.vimPlugins.neoconf-nvim
            # Rust stuff
            # {
            #   plugin = pkgs.vimPlugins.rustaceanvim;
            #   type = "lua";
            #   config = builtins.readFile ./config/plugins/rust.lua;
            # }
            {
              plugin = pkgs.vimExtraPlugins.crates-nvim;
              type = "lua";
              config = builtins.readFile ./config/plugins/crates.lua;
            }
            # Typescript stuff
            {
              plugin = pkgs.vimExtraPlugins.typescript-nvim;
              type = "lua";
              config = builtins.readFile ./config/plugins/typescript.lua;
            }
          ]
        ++
          # Treesitter
          [
            {
              plugin = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
              type = "lua";
              config = builtins.readFile ./config/plugins/treesitter.lua;
            }
            # pkgs.vimPlugins.nvim-treesitter-context
            pkgs.vimPlugins.rainbow-delimiters-nvim
            pkgs.vimExtraPlugins.nvim-ts-context-commentstring
          ]
        ++
          # Extra
          [
            pkgs.vimExtraPlugins.plenary-nvim
            {
              plugin = pkgs.vimExtraPlugins.telescope-nvim;
              type = "lua";
              config = builtins.readFile ./config/plugins/telescope.lua;
            }
            {
              plugin = pkgs.vimExtraPlugins.project-nvim;
              type = "lua";
              config = builtins.readFile ./config/plugins/project.lua;
            }
          ]
        ++
          # Tools
          [
            {
              plugin = pkgs.vimPlugins.diffview-nvim;
              type = "lua";
              config = builtins.readFile ./config/plugins/diffview.lua;
            }
            {
              plugin = pkgs.vimPlugins.neogit;
              type = "lua";
              config = builtins.readFile ./config/plugins/neogit.lua;
            }
            # {
            #   plugin = pkgs.vimExtraPlugins.orgmode;
            #   type = "lua";
            #   config = builtins.readFile ./config/plugins/orgmode.lua;
            # }
            # Wakatime and coding time tracker
            pkgs.vimPlugins.vim-wakatime
          ];
    };
  };
}
