return {
    'ThePrimeagen/harpoon',
    branch = "harpoon2",
    dependencies = { "plenary", 'telescope' },
    config = function()
        local harpoon = require("harpoon")
        -- REQUIRED
        harpoon:setup()
        -- REQUIRED

        local function toggle_telescope(harpoon_files)
            local actions = require("telescope.actions")
            local action_state = require("telescope.actions.state")
            local conf = require("telescope.config").values
            local new_table = require("telescope.finders").new_table
            local function get_file_paths()
                local paths = {}
                for _, item in ipairs(harpoon_files) do
                    table.insert(paths, item.value)
                end

                return paths
            end

            require("telescope.pickers").new({
                --initial_mode = "normal",
            }, {
                prompt_file = "Harpoon",
                finder = require("telescope.finders").new_table({
                    results = get_file_paths(),
                }),
                previewer = conf.file_previewer({}),
                attach_mappings = function(prompt_bufnr, map)
                    actions.select_default:replace(function()
                        actions.close(prompt_bufnr)
                        local selection = action_state.get_selected_entry()[1]
                        for idx, val in ipairs(harpoon_files) do
                            if val.value == selection then
                                harpoon:list():select(idx)
                                break
                            end
                        end
                    end)
                    map("n", "d", function()
                        local selection = action_state.get_selected_entry()
                        for _, val in ipairs(selection) do
                            local item = { value = val }
                            harpoon:list():remove(item)
                        end
                        action_state.get_current_picker(prompt_bufnr):refresh(new_table({
                            results = get_file_paths()
                        }))
                    end)
                    map("n", "q", function() actions.close(prompt_bufnr) end)

                    return true
                end,
                sorter = conf.generic_sorter({}),
            }):find()
        end


        vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
        vim.keymap.set("n", "<leader>d", function() harpoon:list():remove() end)

        --vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list().item) end)
        vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list().items) end)

        vim.keymap.set("n", "<C-1>", function() harpoon:list():select(1) end)
        vim.keymap.set("n", "<C-2>", function() harpoon:list():select(2) end)
        vim.keymap.set("n", "<C-3>", function() harpoon:list():select(3) end)
        vim.keymap.set("n", "<C-4>", function() harpoon:list():select(4) end)

        -- Toggle previous & next buffers stored within Harpoon list
        vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
        vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)

        --vim.cmd('highlight! HarpoonInactive guibg=NONE guifg=#63698c')
        --vim.cmd('highlight! HarpoonActive guibg=NONE guifg=white')
        --vim.cmd('highlight! HarpoonNumberActive guibg=NONE guifg=#7aa2f7')
        --vim.cmd('highlight! HarpoonNumberInactive guibg=NONE guifg=#7aa2f7')
        --vim.cmd('highlight! TabLineFill guibg=NONE guifg=white')
    end,
}
