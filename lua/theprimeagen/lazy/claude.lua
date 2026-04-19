return {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    cmd = {
        "ClaudeCode",
        "ClaudeCodeFocus",
        "ClaudeCodeSend",
        "ClaudeCodeAdd",
        "ClaudeCodeDiffAccept",
        "ClaudeCodeDiffDeny",
    },
    keys = {
        { "<leader>Cc", "<cmd>ClaudeCode<cr>",            desc = "Claude Toggle" },
        { "<leader>Cf", "<cmd>ClaudeCodeFocus<cr>",       desc = "Claude Focus" },
        { "<leader>Cr", "<cmd>ClaudeCode --resume<cr>",   desc = "Claude Resume" },
        { "<leader>CC", "<cmd>ClaudeCode --continue<cr>", desc = "Claude Continue" },
        { "<leader>Cb", "<cmd>ClaudeCodeAdd %<cr>",       desc = "Claude Add Buffer" },
        { "<leader>Cp", "<cmd>ClaudeCodeSend<cr>",        mode = "v", desc = "Claude Send Selection" },
        { "<leader>Cy", "<cmd>ClaudeCodeDiffAccept<cr>",  desc = "Claude Accept Diff" },
        { "<leader>Cn", "<cmd>ClaudeCodeDiffDeny<cr>",    desc = "Claude Deny Diff" },
    },
    opts = {
        terminal = {
            provider = "snacks",
            snacks_win_opts = {
                keys = {
                    -- toggle pane from inside the terminal
                    claude_toggle = {
                        "<leader>Cc",
                        function(self) self:hide() end,
                        mode = "t",
                        desc = "Hide Claude",
                    },
                },
            },
        },
    },
    config = function(_, opts)
        require("claudecode").setup(opts)

        -- auto-enter terminal-insert mode whenever you land in the Claude pane
        vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "TermOpen" }, {
            pattern = "term://*claude*",
            callback = function()
                vim.cmd("startinsert")
            end,
        })
    end,
}
