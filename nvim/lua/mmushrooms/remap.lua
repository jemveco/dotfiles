vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- vim.keymap.set("n", "<C-t>", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

--vim.keymap.set("n", "<leader>vwm", function()
--    require("vim-with-me").StartVimWithMe()
--end)
--vim.keymap.set("n", "<leader>svwm", function()
--    require("vim-with-me").StopVimWithMe()
--end)

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

-- Exit from insert mode
vim.keymap.set("i", "jj", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
--vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- vim.keymap.set("n", "<leader>s", [[:%s#\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>s", [[:%s/\V<C-r><C-w>/NUEVO_TEXTO/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>")

vim.keymap.set("n", "<leader>cs", '<cmd>let @/=""<CR>')

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)

vim.keymap.set({'n', 'v'}, "b", function()
    local current_line = vim.fn.line(".")
    vim.cmd("normal! b")
    if vim.fn.line('.') ~= current_line then
        vim.cmd.normal({ "j0", bang = true})
    end
end, { desc = "Move to previous word without wrapping lines" })

vim.keymap.set({'n', 'v'}, 'w', function()
    local current_line = vim.fn.line('.')
    vim.cmd.normal({ 'w', bang = true })
    if vim.fn.line('.') ~= current_line then
        if vim.api.nvim_get_mode().mode == 'v' then
            vim.cmd.normal({ 'k$h', bang = true })
        else
            vim.cmd.normal({ 'k$', bang = true })
        end
    end
end, { desc = "Move to next word without wrapping lines" })

-- {
-- On LSP attach
local autocmd = vim.api.nvim_create_autocmd
-- Use LspAttach autocmd to only map the following keys
-- after the language server attaches to the current buffer
autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        --local client = vim.lsp.get_client_by_id(ev.data.client_id)
        --local file = assert(io.open("lsp_attach.log", "w"))

        --local result = ""
        --for idx, val in next, ev, nil do
        --    result = result .. idx .. ": " .. tostring(val) .. "\n"
        --end
        --file:write(result)
        --file:close()

        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<leader>f', function()
            vim.lsp.buf.format { async = true }
        end, opts)
    end,
})
-- }
