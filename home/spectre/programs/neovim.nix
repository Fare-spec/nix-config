{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      catppuccin-nvim
      (nvim-treesitter.withPlugins (
        parsers: with parsers; [
          bash
          c
          cpp
          json
          lua
          markdown
          markdown_inline
          nix
          python
          rust
          toml
          vim
          vimdoc
          yaml
        ]
      ))

      plenary-nvim
      telescope-nvim

      nvim-lspconfig
    ];

    vimAlias = true;

    initLua = ''
      -- Line numbers
      vim.opt.number = true
      vim.opt.relativenumber = true

      -- Indentation
      vim.opt.expandtab = true
      vim.opt.tabstop = 4
      vim.opt.shiftwidth = 4
      vim.opt.softtabstop = 4
      vim.opt.smartindent = true

      -- Search
      vim.opt.ignorecase = true
      vim.opt.smartcase = true
      vim.opt.incsearch = true

      -- UI
      vim.opt.termguicolors = true
      vim.opt.signcolumn = "yes"
      vim.opt.cursorline = true
      vim.opt.scrolloff = 8

      -- Editing
      vim.opt.wrap = false
      vim.opt.mouse = "a"
      vim.opt.clipboard = "unnamedplus"

      -- Files
      vim.opt.swapfile = false
      vim.opt.backup = false
      vim.opt.undofile = true

      -- Faster UI updates
      vim.opt.updatetime = 250
      vim.opt.timeoutlen = 300

      -- Better splits
      vim.opt.splitright = true
      vim.opt.splitbelow = true

      -- Theme
      require("catppuccin").setup({
        flavour = "macchiato",
        transparent_background = false,
        term_colors = true,
      })

      vim.cmd.colorscheme("catppuccin")

      -- Treesitter
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "bash",
          "c",
          "cpp",
          "json",
          "lua",
          "markdown",
          "nix",
          "python",
          "rust",
          "toml",
          "vim",
          "yaml",
        },
        callback = function()
          vim.treesitter.start()
        end,
      })

      -- Telescope
      require("telescope").setup({
        defaults = {
          sorting_strategy = "ascending",
          layout_config = {
            prompt_position = "top",
          },
        },
      })


      -- LSP

      -- Make Lua understand Neovim's `vim` API.
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
            },
          },
        },
      })

      local servers = {
        "nil_ls",         -- Nix
        "clangd",         -- C / C++
        "rust_analyzer",  -- Rust
        "pyright",        -- Python
        "lua_ls",         -- Lua
      }

      for _, server in ipairs(servers) do
        vim.lsp.enable(server)
      end


      -- Built-in LSP completion
      vim.opt.completeopt = {
        "menu",
        "menuone",
        "noselect",
        "popup",
      }

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)

          if client and client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, args.buf, {
              autotrigger = true,
            })
          end
        end,
      })

      vim.lsp.config("nil_ls", {
      settings = {
        ["nil"] = {
          formatting = {
            command = { "nixfmt" },
          },
        },
      },
    })
      vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.nix",
      callback = function()
        vim.lsp.buf.format({
          async = false,
          timeout_ms = 3000,
        })
      end,
    })
    '';
  };
}
