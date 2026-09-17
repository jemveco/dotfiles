return {
    "lervag/vimtex",
    lazy = false,     -- we don't want to lazy load VimTeX
    -- tag = "v2.15", -- uncomment to pin to a specific release
    init = function()
        vim.g.vimtex_compiler_latexmk = {
            executable = "latexmk",
            options = {
                "-pdf",
                "-interaction=nonstopmode",
                "-synctex=1",
                -- "-outdir=build", -- Redirects main output and PDF
                "-auxdir=build", -- Redirects auxiliary files
                "-file-line-error",
                -- "%f"
            },
        }
        vim.g.vimtex_view_method = "zathura"

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "tex",
            callback = function(ev)
                vim.treesitter.stop(ev.buf, "latex")
                -- Enable visual line wrapping
                vim.opt_local.wrap = true
                vim.opt_local.linebreak = true

                -- Prevent Neovim from inserting hard line breaks while you type
                vim.opt_local.textwidth = 0
                -- Remove 't' to stop automatic text wrapping
                vim.opt_local.formatoptions:remove("t")

                -- The Magic Keymap: Instantly reformat a chopped paragraph 
                -- Pressing 'gwip' will reflow your text back into a single continuous line, 
                -- causing single line breaks to disappear and match standard viewer output.
                vim.keymap.set("n", "<leader>mp", "gwip", { desc = "Reflow paragraph (Remove single line breaks)" })
                -- Move per visual line instead of logic line
                vim.keymap.set({ "n", "x" }, "j", "gj", { buffer = true, desc = "Move down per visual line" })
                vim.keymap.set({ "n", "x" }, "k", "gk", { buffer = true, desc = "Move up per visual line" })
            end,
        })
        vim.keymap.set({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP: code action" })
    end
}
