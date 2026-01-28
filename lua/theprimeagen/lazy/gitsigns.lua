return {
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                signs = {
                    add = { text = "┃" },
                    change = { text = "┃" },
                    delete = { text = "_" },
                    topdelete = { text = "‾" },
                    changedelete = { text = "~" },
                },
                signcolumn = true,
                numhl = false,
                linehl = false,
                word_diff = false,
                watch_gitdir = {
                    interval = 1000,
                    follow_files = true,
                },
                auto_attach = true,
                attach_to_untracked = false,
                current_line_blame = false, -- toggle with <leader>gbl
                current_line_blame_opts = {
                    virt_text = true,
                    virt_text_pos = "eol",
                    delay = 1000,
                },
                sign_priority = 6,
                update_debounce = 100,
                status_formatter = nil,
                max_file_length = 40000,
                preview_config = {
                    border = "single",
                    style = "minimal",
                    relative = "cursor",
                    row = 0,
                    col = 1,
                },
            })

            local gs = require("gitsigns")

            -- Keymaps
            vim.keymap.set("n", "<leader>gbl", gs.toggle_current_line_blame, { desc = "Toggle blame line" })
            vim.keymap.set("n", "<leader>gb", gs.blame_line, { desc = "Show blame" })
            vim.keymap.set("n", "<leader>gd", gs.diffthis, { desc = "Diff this" })
            vim.keymap.set("n", "<leader>gD", function() gs.diffthis("~") end, { desc = "Diff against parent" })
            vim.keymap.set("n", "<leader>ghs", gs.stage_hunk, { desc = "Stage hunk" })
            vim.keymap.set("n", "<leader>ghr", gs.reset_hunk, { desc = "Reset hunk" })
            vim.keymap.set("n", "<leader>ghS", gs.stage_buffer, { desc = "Stage buffer" })
            vim.keymap.set("n", "<leader>ghR", gs.reset_buffer, { desc = "Reset buffer" })
            vim.keymap.set("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
            vim.keymap.set("n", "<leader>gp", gs.preview_hunk, { desc = "Preview hunk" })
        end,
    }
}
