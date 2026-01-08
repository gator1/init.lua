return {
  "sourcegraph/amp.nvim",
  branch = "main",
  lazy = false,
  opts = {
    auto_start = true,
    log_level = "info",
  },
  config = function(_, opts)
    local ok_amp, amp = pcall(require, "amp")
    if ok_amp and amp.setup then
      amp.setup(opts)
    end

    local ok_msg, msg = pcall(require, "amp.message")
    if not ok_msg then
      vim.notify("amp.message API not available", vim.log.levels.WARN)
      return
    end

    vim.api.nvim_create_user_command("AmpStartHere", function()
      vim.cmd("AmpStart")
      vim.defer_fn(function()
        local amp = require("amp")
        if amp.state.port then
          vim.notify("Amp server running on port " .. amp.state.port, vim.log.levels.INFO)
        else
          vim.notify("Amp server failed to start", vim.log.levels.ERROR)
        end
      end, 300)
    end, { desc = "Amp: start plugin server and show status" })

    vim.api.nvim_create_user_command("AmpStopHere", function()
      vim.cmd("AmpStop")
      vim.notify("Amp server stopped", vim.log.levels.INFO)
    end, { desc = "Amp: stop plugin server" })

    vim.api.nvim_create_user_command("AmpStatusHere", function()
      local amp = require("amp")
      if amp.state.port then
        local status = amp.state.connected and "connected" or "waiting for clients"
        vim.notify("Amp: port " .. amp.state.port .. " (" .. status .. ")", vim.log.levels.INFO)
      else
        vim.notify("Amp server not running", vim.log.levels.WARN)
      end
    end, { desc = "Amp: show status as notification" })

    vim.api.nvim_create_user_command("AmpSend", function(opts)
      local q = opts.args or ""
      if q == "" then
        vim.notify("Usage: AmpSend <message>", vim.log.levels.INFO)
        return
      end
      msg.send_message(q)
      vim.notify("Sent to Amp: " .. q, vim.log.levels.INFO)
    end, { nargs = "*", desc = "Amp: send a message to agent" })

    vim.api.nvim_create_user_command("AmpSendBuffer", function()
      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      msg.send_message(table.concat(lines, "\n"))
      vim.notify("Sent current buffer to Amp", vim.log.levels.INFO)
    end, { desc = "Amp: send current buffer" })

    vim.api.nvim_create_user_command("AmpPromptSelection", function(opts)
      local lines = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, false)
      msg.send_to_prompt(table.concat(lines, "\n"))
      vim.notify("Added selection to Amp prompt", vim.log.levels.INFO)
    end, { range = true, desc = "Amp: add selection to prompt" })

    vim.api.nvim_create_user_command("AmpPromptRef", function(opts)
      local bufname = vim.api.nvim_buf_get_name(0)
      if bufname == "" then
        vim.notify("Buffer has no filename", vim.log.levels.WARN)
        return
      end
      local rel = vim.fn.fnamemodify(bufname, ":.")
      local ref = "@" .. rel
      if opts.line1 ~= opts.line2 then
        ref = ref .. "#L" .. opts.line1 .. "-" .. opts.line2
      elseif opts.line1 > 1 then
        ref = ref .. "#L" .. opts.line1
      end
      msg.send_to_prompt(ref)
      vim.notify("Added ref to Amp prompt: " .. ref, vim.log.levels.INFO)
    end, { range = true, desc = "Amp: add @file#Lstart-end to prompt" })

    vim.keymap.set("n", "<leader>Aa", ":AmpStartHere<CR>", { silent = true, desc = "Amp Start+Status" })
    vim.keymap.set("n", "<leader>As", ":AmpStatusHere<CR>", { silent = true, desc = "Amp Status" })
    vim.keymap.set("n", "<leader>Ax", ":AmpStopHere<CR>",  { silent = true, desc = "Amp Stop" })
    vim.keymap.set("n", "<leader>Am", ":AmpSend ",         { silent = false, desc = "Amp Send (type message)" })
    vim.keymap.set("n", "<leader>Ab", ":AmpSendBuffer<CR>",{ silent = true, desc = "Amp Send Buffer" })
    vim.keymap.set("x", "<leader>Ap", ":AmpPromptSelection<CR>", { silent = true, desc = "Amp Prompt Selection" })
    vim.keymap.set("n", "<leader>Ar", ":AmpPromptRef<CR>", { silent = true, desc = "Amp Prompt Ref" })
  end,
}
