return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    delay = 300,  -- show popup after 300ms
    icons = {
      mappings = false,
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps",
    },
  },
}
