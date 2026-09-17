return {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    config = function()
        require("tiny-inline-diagnostic").setup({
            preset = "powerline",
        })
        vim.diagnostic.config({
            signs = {
                active = true,
                text = {
                    [vim.diagnostic.severity.ERROR] = " ",
                    [vim.diagnostic.severity.WARN]  = " ",
                    [vim.diagnostic.severity.HINT]  = "󰞋 ",
                    [vim.diagnostic.severity.INFO]  = " ",
                },
            },
            virtual_text = false,
            }) -- Disable Neovim's default virtual text diagnostics

    end,
}
