{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;

    # Language servers and formatting tools
    extraPackages = with pkgs; [
      nil
      nixfmt
      clang-tools
      rust-analyzer
      pyright
      lua-language-server
    ];

    plugins = with pkgs.vimPlugins; [
      # Theme
      catppuccin-nvim

      # Syntax highlighting
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

      # File search
      plenary-nvim
      telescope-nvim

      # LSP
      nvim-lspconfig

      # Completion
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline

      # Snippets
      luasnip
      cmp_luasnip
      friendly-snippets
    ];

    initLua = ''
      --------------------------------------------------
      -- General settings
      --------------------------------------------------

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

      -- Performance
      vim.opt.updatetime = 250
      vim.opt.timeoutlen = 300

      -- Splits
      vim.opt.splitright = true
      vim.opt.splitbelow = true

      -- Completion behavior
      vim.opt.completeopt = "menu,menuone,noselect"


      --------------------------------------------------
      -- Theme
      --------------------------------------------------

      require("catppuccin").setup({
        flavour = "macchiato",
        transparent_background = false,
        term_colors = true,

        integrations = {
          cmp = true,
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
            },
          },
        },
      })

      vim.cmd.colorscheme("catppuccin")


      --------------------------------------------------
      -- Treesitter
      --------------------------------------------------

      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "sh",
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
          pcall(vim.treesitter.start)
        end,
      })


      --------------------------------------------------
      -- Telescope
      --------------------------------------------------

      require("telescope").setup({
        defaults = {
          sorting_strategy = "ascending",
          layout_config = {
            prompt_position = "top",
          },
        },
      })

      vim.keymap.set("n", "<leader>ff",
        "<cmd>Telescope find_files<CR>",
        { desc = "Find files" }
      )

      vim.keymap.set("n", "<leader>fg",
        "<cmd>Telescope live_grep<CR>",
        { desc = "Search text" }
      )

      vim.keymap.set("n", "<leader>fb",
        "<cmd>Telescope buffers<CR>",
        { desc = "Find buffers" }
      )


      --------------------------------------------------
      -- Diagnostics
      --------------------------------------------------

      vim.diagnostic.config({
        -- Display errors below the current line
        virtual_text = false,
        virtual_lines = {
          current_line = true,
        },

        -- Error indicators
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "E",
            [vim.diagnostic.severity.WARN] = "W",
            [vim.diagnostic.severity.INFO] = "I",
            [vim.diagnostic.severity.HINT] = "H",
          },
        },

        underline = true,
        update_in_insert = false,
        severity_sort = true,

        float = {
          border = "rounded",
          source = true,
          focusable = false,
        },
      })

      -- Diagnostic navigation
      vim.keymap.set("n", "[d", function()
        vim.diagnostic.jump({
          count = -1,
          float = true,
        })
      end, { desc = "Previous diagnostic" })

      vim.keymap.set("n", "]d", function()
        vim.diagnostic.jump({
          count = 1,
          float = true,
        })
      end, { desc = "Next diagnostic" })

      vim.keymap.set("n", "<leader>e", function()
        vim.diagnostic.open_float()
      end, { desc = "Show diagnostic" })

      vim.keymap.set("n", "<leader>q", function()
        vim.diagnostic.setloclist()
      end, { desc = "Diagnostic list" })


      --------------------------------------------------
      -- LSP
      --------------------------------------------------

      local capabilities =
        require("cmp_nvim_lsp").default_capabilities()

      -- Apply completion capabilities to every server
      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      -- Lua
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
          },
        },
      })

      -- Nix
      vim.lsp.config("nil_ls", {
        settings = {
          ["nil"] = {
            formatting = {
              command = { "nixfmt" },
            },
          },
        },
      })

      -- Rust
      vim.lsp.config("rust_analyzer", {
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = true,
            check = {
              command = "clippy",
            },
          },
        },
      })

      -- Enable language servers
      vim.lsp.enable({
        "nil_ls",
        "clangd",
        "rust_analyzer",
        "pyright",
        "lua_ls",
      })


      --------------------------------------------------
      -- LSP keybindings
      --------------------------------------------------

      vim.keymap.set("n", "gd",
        vim.lsp.buf.definition,
        { desc = "Go to definition" }
      )

      vim.keymap.set("n", "gr",
        vim.lsp.buf.references,
        { desc = "Find references" }
      )

      vim.keymap.set("n", "K",
        vim.lsp.buf.hover,
        { desc = "Show documentation" }
      )

      vim.keymap.set("n", "<leader>rn",
        vim.lsp.buf.rename,
        { desc = "Rename symbol" }
      )

      vim.keymap.set("n", "<leader>ca",
        vim.lsp.buf.code_action,
        { desc = "Code action" }
      )

      vim.keymap.set("n", "<leader>f", function()
        vim.lsp.buf.format({
          async = false,
          timeout_ms = 3000,
        })
      end, { desc = "Format file" })


      --------------------------------------------------
      -- Snippets
      --------------------------------------------------

      local luasnip = require("luasnip")

      require("luasnip.loaders.from_vscode").lazy_load()

      luasnip.config.setup({
        history = true,
        updateevents = "TextChanged,TextChangedI",
      })


      --------------------------------------------------
      -- Completion
      --------------------------------------------------

      local cmp = require("cmp")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        completion = {
          completeopt = "menu,menuone,noselect",
          keyword_length = 1,
        },

        preselect = cmp.PreselectMode.None,

        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },

        experimental = {
          ghost_text = false,
        },

        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),

          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),

          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),

          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<CR>"] = cmp.mapping.confirm({
            select = false,
          }),
        }),

        formatting = {
          fields = { "abbr", "kind", "menu" },

          format = function(entry, item)
            local labels = {
              nvim_lsp = "[LSP]",
              luasnip = "[Snippet]",
              buffer = "[Buffer]",
              path = "[Path]",
            }

            item.menu = labels[entry.source.name] or ""
            return item
          end,
        },

        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip", priority = 750 },
          { name = "path", priority = 500 },
        }, {
          {
            name = "buffer",
            priority = 250,
            keyword_length = 3,
          },
        }),

        sorting = {
          priority_weight = 2,
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },

        performance = {
          debounce = 60,
          throttle = 30,
          max_view_entries = 15,
        },
      })


      --------------------------------------------------
      -- Command-line completion
      --------------------------------------------------

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
        matching = {
          disallow_symbol_nonprefix_matching = false,
        },
      })


      --------------------------------------------------
      -- Automatic formatting
      --------------------------------------------------

      local format_group = vim.api.nvim_create_augroup(
        "FormatOnSave",
        { clear = true }
      )

      -- Nix
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = format_group,
        pattern = "*.nix",

        callback = function()
          vim.lsp.buf.format({
            async = false,
            timeout_ms = 3000,
            filter = function(client)
              return client.name == "nil_ls"
            end,
          })
        end,
      })

      -- C / C++
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = format_group,
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
