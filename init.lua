-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Update neo-tree settings
require("neo-tree").setup {
  --filesystem = {
  --  group_empty_dirs = true
  --},
  window = {
    width = 50,
    mappings = {
      ["m"] = { "move", config = { show_path = "absolute" } }
    }
  },
  default_component_configs = {
    file_size = { enabled = false },
    type = { enabled = false },
    last_modified = { enabled = false},
    created = { enabled = false }
  }
}

-- keep the DAP UI open after a debug session ends by setting listeners to no-ops (LazyVim makes has these calling dapui.close())
local dap = require("dap")
dap.listeners.before.event_terminated["dapui_config"] = function() end
dap.listeners.before.event_exited["dapui_config"]     = function() end
