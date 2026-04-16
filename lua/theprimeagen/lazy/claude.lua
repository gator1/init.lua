return {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = true,
    cmd = {
        "ClaudeCode",
        "ClaudeCodeFocus",
        "ClaudeCodeSend",
        "ClaudeCodeAdd",
        "ClaudeCodeDiffAccept",
        "ClaudeCodeDiffDeny",
    },
    keys = {
        { "<leader>Cc", "<cmd>ClaudeCode<cr>",           desc = "Claude Toggle" },
        { "<leader>Cf", "<cmd>ClaudeCodeFocus<cr>",      desc = "Claude Focus" },
        { "<leader>Cr", "<cmd>ClaudeCode --resume<cr>",  desc = "Claude Resume" },
        { "<leader>CC", "<cmd>ClaudeCode --continue<cr>", desc = "Claude Continue" },
        { "<leader>Cb", "<cmd>ClaudeCodeAdd %<cr>",      desc = "Claude Add Buffer" },
        { "<leader>Cp", "<cmd>ClaudeCodeSend<cr>",       mode = "v", desc = "Claude Send Selection" },
        { "<leader>Cy", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Claude Accept Diff" },
        { "<leader>Cn", "<cmd>ClaudeCodeDiffDeny<cr>",   desc = "Claude Deny Diff" },
    },
}
