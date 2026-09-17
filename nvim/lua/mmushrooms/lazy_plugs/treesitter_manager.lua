return {
    {
        'romus204/tree-sitter-manager.nvim',
        dependencies = {},
        config = function()
            require('tree-sitter-manager').setup({
                ensure_installed = {
                    'lua', 'rust', 'c', 'zig',
                    'python', 'html', 'markdown',
                    'markdown_inline','typst', 'yaml',
                },
                auto_install = false,
                nohighlight = {
                    "latex",
                },
            })
        end,
    },
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        branch = 'main',
        init = function()
            vim.g.no_plugin_maps = true
        end,
        config = function()
            require('nvim-treesitter-textobjects').setup({
                select = {
                    lookahead = true,
                    selection_modes = {
                        ['@parameter.outer'] = 'v',
                        ['@function.outer'] = 'V',
                        ['@class.outer'] = 'V',
                    },
                }
            })

            -- keymaps
            vim.keymap.set({ "x", "o" }, "<C-A>f", function()
                require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "im", function()
                require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
            end)
            vim.keymap.set({ "n" }, "<C-A>p", function()
                require("nvim-treesitter-textobjects.select").select_textobject("@parameter.outer", "textobjects")
            end)
            vim.keymap.set({ "n" }, "<C-I>p", function()
                require("nvim-treesitter-textobjects.select").select_textobject("@parameter.inner", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "ac", function()
                require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "ic", function()
                require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
            end)
            -- You can also use captures from other query groups like `locals.scm`
            --vim.keymap.set({ "x", "o" }, "as", function()
            --    require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
            --end)
            vim.keymap.set({ "x", "o" }, "<C-A>b", function()
                require("nvim-treesitter-textobjects.select").select_textobject("@block.outer", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "ib", function()
                require("nvim-treesitter-textobjects.select").select_textobject("@block.inner", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "<C-A>c", function()
                require("nvim-treesitter-textobjects.select").select_textobject("@comment.outer", "textobjects")
            end)

            -- Comments remaps
            local function toggle_comment(query, look_cursor)
                look_cursor = look_cursor or true
                local line = vim.fn.getline('.')
                local comment_str = vim.bo.commentstring:match("^(.-)%%s") or "#"
                comment_str = vim.trim(comment_str)
                local is_comment = line:match("^%s*" .. vim.pesc(comment_str)) ~= nil
                -- vim.print("line: ", line, ", comment_str: ", comment_str, ", is_comment: ", is_comment)

                local cursor_pos = vim.api.nvim_win_get_cursor(0) -- Gets cursor position this is to restore his postition
                if is_comment then
                    vim.cmd.normal("gcgc")
                else
                    require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")

                    -- vim.schedule(function()
                    vim.cmd.normal("gc")
                        -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('gc', true, false, true), 'm', false)
                    -- end)
                end

                if look_cursor then
                    vim.api.nvim_win_set_cursor(0, cursor_pos) -- Restores cursor position
                end
            end

            -- vim.keymap.set('n', '<C-}>', 'gc<C-A>f', { remap = true, desc = 'Toggles a comment around a function' })
            vim.keymap.set("n", "<C-{>", function()
                toggle_comment("@block.outer")
            end, { remap = true, desc = "Toggles a comment around a block" })
            vim.keymap.set("n", "<C-}>", function()
                toggle_comment("@function.outer")
            end, { remap = true, desc = "Toggles a comment around a function" })
            -- vim.keymap.set("n", "<C-;>", function()
            --     toggle_comment("@parameter.outer")
            -- end, { remap = true, desc = "Toggles a comment around a function header" })
            vim.keymap.set("n", "<C-l>", function()
                vim.cmd.normal("gcc")
            end, { remap = true, desc = "Toggles a comment around a single line" })
        end,
    }
}
