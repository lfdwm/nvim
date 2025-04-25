return {
  {
    "mfussenegger/nvim-jdtls",
    opts = function(_, opts)
      local opens = table.concat({
        "--add-opens", "java.base/java.lang=ALL-UNNAMED",
        "--add-opens", "java.base/java.util=ALL-UNNAMED",
        "--add-modules", "java.se",
        "--add-exports", "java.base/jdk.internal.ref=ALL-UNNAMED",
        "--add-opens", "java.naming/javax.naming.spi=ALL-UNNAMED",
        "--add-opens", "java.base/java.lang=ALL-UNNAMED",
        "--add-opens", "java.base/java.util=ALL-UNNAMED",
        "--add-opens", "java.base/sun.net.www.protocol.jar=ALL-UNNAMED",
        "--add-opens", "java.base/java.net=ALL-UNNAMED",
        "--add-opens", "java.base/sun.net.www=ALL-UNNAMED",
        "--add-opens", "java.base/java.io=ALL-UNNAMED",
        "--add-opens", "java.base/sun.security.util=ALL-UNNAMED",
        "--add-opens", "java.base/java.nio=ALL-UNNAMED",
        "--add-opens", "java.base/sun.nio.ch=ALL-UNNAMED",
        "--add-opens", "java.management/sun.management=ALL-UNNAMED",
        "--add-opens", "jdk.management/com.sun.management.internal=ALL-UNNAMED",
      }, " ")

      -- apply to *every* debug or test run
      opts.dap.config_overrides.vmArgs  = opens

      -- and make the <leader>t* test keymaps inherit it
      -- (actually, seems to be unneccesary)
      --opts.test = opts.test or {}
      --opts.test.config_overrides = { vmArgs = opens }
    end,
  },
}
