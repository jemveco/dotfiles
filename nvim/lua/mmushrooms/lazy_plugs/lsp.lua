return {
    -- LSP support
    -- 'neovim/nvim-lspconfig',
    -- Snippets
    {
        'L3MON4D3/LuaSnip',
        build = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function ()
            require("luasnip.loaders.from_vscode").lazy_load()
        end
    },
    -- LSP
    {
        -- 'williamboman/mason-lspconfig.nvim',
        'mason-org/mason-lspconfig.nvim',
        dependencies = {
            -- Language Servers management from neovim
            -- 'williamboman/mason.nvim',
            'mason-org/mason.nvim',
            'neovim/nvim-lspconfig', -- Required for the specific server's config
            -- 'williamboman/mason-lspconfig.nvim',
            -- Autocompletion
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/nvim-cmp',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
            'j-hui/fidget.nvim',
        },
        opts = {
            automatic_enable = false,
            ensure_installed = {
                'clangd',
                'rust_analyzer',
                'lua_ls',
                'pyrefly',
                'pylsp',
                'texlab',
                'ltex_plus',
            },
        },
        config = function(_, opts)
            require('fidget').setup()
            require('mason').setup()
            require("mason-lspconfig").setup(opts)

            local cmp = require('cmp')
            local cmplsp = require('cmp_nvim_lsp')
            local capabilities = vim.tbl_deep_extend(
                'force',
                {},
                vim.lsp.protocol.make_client_capabilities(),
                cmplsp.default_capabilities()
            )
            local luasnip = require('luasnip')

            vim.cmd[[set completeopt+=menuone,noselect,popup]]
            vim.lsp.config("*", { root_markers = { ".git", ".hg" }, capabilities = capabilities })
            vim.lsp.config("lua_ls", {
                settings = {
                    Lua = {
                        runtime = { version = "LuaJIT", },
                        diagnostics = {
                            globals = {
                                'vim', 'it', 'describe',
                                'before_each', 'after_each',
                                'awesome',
                            }
                        }
                    }
                }
            })
            vim.lsp.config("clangd", {
                cmd = { "clangd", "--compile-commands-dir=./build" },
            })
            vim.lsp.config("pyrefly", {
                on_attach = function(client, _)
                    client.server_capabilities.diagnosticProvider = false
                    client.server_capabilities.documentSymbolProvider = false
                end,
            })
            vim.lsp.config("pylsp", {
                on_attach = function(client, _)
                    client.server_capabilities.completionProvider = false
                end,
                settings = {
                    pylsp = {
                        plugins = {
                            pycodestyle = {
                                enabled = true,
                                ignore = { "E501", "W391" },
                                maxLineLength = 150,
                            },
                            pyflakes = { enabled = true, },
                            mccabe = { threshold = 20, },
                        }
                    }
                },
            })
            vim.lsp.config("texlab", {
                settings = {
                    texlab = {
                        build = {
                            -- args = {
                            --     "-pdf",
                            --     "-interaction=nonstopmode",
                            --     "-synctex=1",
                            --     -- "-outdir=build", -- Redirects main output and PDF
                            --     "-auxdir=build", -- Redirects auxiliary files
                            --     "%f"
                            -- },
                            onSave = false,
                        }
                    }
                },
            })
            vim.lsp.config("ltex_plus", {
                on_attach = function(client, _)
                    client.server_capabilities.completionProvider = false
                end,
                cmd = { "ltex-ls-plus" },
                filetypes = { "latex", "tex", "markdown" },
                settings = {
                    ltex = {
                        language = "es-ES",
                        dictionary = {
                            ["es"] = {
                                "height", "width", "depth",
                                "VAR", "VAD", "VLM", "PCA",
                                "ésima", "aprendibles", "precalculada",
                                "Anomaly", "anomaly", "UCF", "UCA", "Crime"
                            },
                        },
                        environments = {
                            ["equation"] = "ignore"
                        },
                    },
                },
            })

            -- local servers = {
            --     'clangd',
            --     'rust_analyzer',
            --     'lua_ls',
            --     'pyrefly',
            --     'pylsp',
            --     'texlab',
            --     'ltex-ls-plus',
            -- }

            -- for _, server in ipairs(servers) do
            for _, server in ipairs(opts.ensure_installed) do
                vim.lsp.enable(server)
            end

            cmp.setup({
                preselect = cmp.PreselectMode.None,
                snippet = {
                    -- REQUIRED - snippet engine
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered({
                        border = "rounded",
                        winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None',
                        side_padding = 0,
                    }),
                    documentation = cmp.config.window.bordered({
                        border = "rounded",
                        winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None',
                    }),
                },
                mapping = {
                    ["<CR>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            if luasnip.expandable() then
                                luasnip.expand()
                            elseif cmp.get_selected_entry() then
                                cmp.confirm({
                                    -- select = false,
                                    select = true,
                                })
                            else
                                cmp.close()
                                fallback()
                            end
                        else
                            fallback()
                        end
                    end),

                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.locally_jumpable(1) then
                            luasnip.jump(1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<C-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() and cmp.get_selected_entry() then
                            cmp.abort()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                },

                -- sources = cmp.config.sources({
                --     { name = 'nvim_lsp' },
                --     { name = 'luasnip' }, -- For luasnip users.
                -- }, {
                --     { name = 'buffer' },
                -- })
                sources = {
                    { name = "nvim_lsp" },
                    { name = 'luasnip' }, -- For luasnip users.
                    { name = 'buffer' },
                },
                formatting = {
                    fields = { "abbr", "kind", "menu" },
                    format = function(entry, vim_item)
                        local source_names = {
                            nvim_lsp = "[LSP]",
                            luasnip = "[Snippet]",
                            buffer = "[Buffer]",
                            path = "[Path]",
                            cmdline = "[Cmd]",
                        }
                        vim_item.menu = source_names[entry.source.name] or string.format("[%s]", entry.source.name)
                        return vim_item
                    end,
                },
            })

            -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline({ '/', '?' }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = 'buffer' }
                }
            })

            -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = 'path' }
                }, {
                    { name = 'cmdline' }
                })
            })
        end,
    }
}
