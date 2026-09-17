return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons", -- optional, but recommended
    },
    lazy = false, -- neo-tree will lazily load itself
    config = function()
        vim.keymap.set("n", "<C-t>", "<Cmd>Neotree toggle reveal<CR>")
        require("neo-tree").setup({
            close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
            popup_border_style = "", -- or "" to use 'winborder' on Neovim v0.11+
            filesystem = {
                filtered_items = {
                    hide_dotfiles = false,
                },
                hijack_netrw_behavior = "open_current",
            },
            event_handlers = {
                {
                    event = "file_opened",
                    handler = function(file_path)
                        -- Auto-close Neo-tree window once a file is opened
                        require("neo-tree.command").execute({ action = "close" })
                    end
                },
            }
        })
    end
}
