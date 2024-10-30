-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Update neo-tree settings
require("neo-tree").setup({
  --filesystem = {
  --  group_empty_dirs = true
  --},
  window = {
    width = 50,
    mappings = {
      ["m"] = { "move", config = { show_path = "absolute" } }
    }
  }
})
