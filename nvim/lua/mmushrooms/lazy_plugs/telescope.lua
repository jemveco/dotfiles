return {
    "nvim-telescope/telescope.nvim",
    -- tag = "0.1.5",
    branch = "master",
    dependencies = { 'plenary' },
    name = 'telescope',
    priority = 1000,
    config = function()
        require('telescope').setup({
            file_ignore_patterns = { 'node%_modules/.*' },
        })

        local builtin = require('telescope.builtin')
        local actions = require("telescope.actions")
        vim.keymap.set('n', '<leader>ds', function()
            builtin.lsp_document_symbols({
                symbols = {
                    "Module", "Package", "Struct", "Class", "Property",
                    "Field", "Constructor", "Method", "Enum", "Interface",
                    "Function", "Constant", "Variable", "Number", "Boolean",
                    "Array", "String", "Object", "Key", "EnumMember", "Null",
                    "Event", "Operator", "TypeParameter",
                },
                symbol_width = 50,
                attach_mappings = function(_, map)
                    map("n", "q", actions.close)
                    return true
                end
            })
        end)
    end,
}
