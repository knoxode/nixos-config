local shared = require("shared")

hl.on("workspace.created", function(workspace)
  if workspace.name == "special:terminal" and workspace.is_empty then
    hl.dsp.exec_cmd(shared.terminal)()
  end
end)
