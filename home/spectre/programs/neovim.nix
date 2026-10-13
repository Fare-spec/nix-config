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

      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
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

        local capabilities = require("cmp_nvim_lsp").default_capabilities()

      vim.lsp.config("nil_ls", {
        settings = {
          ["nil"] = {
            formatting = {
              command = { "nixfmt" },
            },
          },
        },
      })

        for _, server in ipairs(servers) do
          vim.lsp.config(server, {
            capabilities = capabilities,
          })

          vim.lsp.enable(server)
        end


        -- Completion
        local cmp = require("cmp")

        cmp.setup({
          completion = {
            completeopt = "menu,menuone,noselect",
          },

          mapping = cmp.mapping.preset.insert({
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-n>"] = cmp.mapping.select_next_item(),
            ["<C-p>"] = cmp.mapping.select_prev_item(),

            ["<CR>"] = cmp.mapping.confirm({
              select = false,
            }),
          }),

          sources = cmp.config.sources({
            { name = "nvim_lsp" },
          }, {
            { name = "buffer" },
            { name = "path" },
          }),
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
            vim.api.nvim_create_autocmd("BufWritePre", {
              pattern = {
                "*.c",
                "*.h",
                "*.cc",
                "*.cpp",
                "*.cxx",
                "*.hpp",
                "*.hxx",
              },
              callback = function()
                vim.lsp.buf.format({
                  async = false,
                  timeout_ms = 3000,
                  filter = function(client)
                    return client.name == "clangd"
                  end,
                })
              end,
            })
    '';
  };
}
