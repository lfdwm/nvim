return {
  "folke/trouble.nvim",
  opts = {
    auto_refresh = false
  },
  keys = {
    { "<leader>cS", function ()
      if require("trouble").is_open() then
        vim.cmd("Trouble lsp_no_outgoing_calls refresh")
      else
        vim.cmd("Trouble lsp_no_outgoing_calls toggle win.position=right")
      end
    end },
  }
}
