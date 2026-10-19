-- helpers/workspaces.lua

local M = {}

---@param monitors HL.Monitor[]
function M.assign(monitors)
  if #monitors == 1 then
    for i = 1, 10 do
      hl.workspace_rule({
        workspace = tostring(i),
        monitor = monitors[1].name,
      })
    end
  elseif #monitors == 2 then
    local external_mon_name = nil
    for _, mon in ipairs(monitors) do
      if mon.name ~= "eDP-1" then
        external_mon_name = mon.name
        break
      end
    end

    if not external_mon_name then
      return
    end

    for i = 1, 5 do
      hl.workspace_rule({
        workspace = tostring(i),
        monitor = external_mon_name,
      })
      hl.workspace_rule({
        workspace = tostring(i + 5),
        monitor = "eDP-1",
      })
    end
  end
end

function M.generate_binds(monitors)
  -- Future workspace-dependent bindings
end

return M
