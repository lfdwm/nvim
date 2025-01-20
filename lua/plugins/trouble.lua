return {
  "folke/trouble.nvim",
  opts = {
    auto_refresh = false
  },
  keys = {
    { "<leader>cS", function ()
      if require("trouble").is_open() then
        vim.cmd("Trouble lsp refresh")
      else
        vim.cmd("Trouble lsp toggle")
      end
    end },
  }
}
