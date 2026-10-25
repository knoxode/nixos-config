local shared = require("shared")

hl.workspace_rule({
  workspace = "special:terminal",
  on_created_empty = shared.terminal,
})
