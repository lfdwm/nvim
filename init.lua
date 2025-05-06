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

-- Default to openapi 3.0 instead of 3.1
-- require("lspconfig").yamlls.setup {
--   settings = {
--     yaml = {
--       schemaStore = {
--         -- You must disable built-in schemaStore support if you want to use
--         -- this plugin and its advanced options like `ignore`.
--         enable = false,
--         -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
--         url = "",
--       },
--       schemas = require("schemastore").yaml.schemas {
--         replace = {
--           ["openapi.json"] = {
--             description = "Open API documentation files",
--             fileMatch = { "openapi.json", "openapi.yml", "openapi.yaml" },
--             name = "openapi.json",
--             url = "https://spec.openapis.org/oas/3.1/schema/2022-10-07",
--             versions = {
--               ["3.0"] = "https://spec.openapis.org/oas/3.0/schema/2021-09-28",
--               ["3.1"] = "https://spec.openapis.org/oas/3.1/schema/2022-10-07"
--             }
--           },
--         },
--       },
--       validate = { enable = true },
--     },
--   },
-- }
