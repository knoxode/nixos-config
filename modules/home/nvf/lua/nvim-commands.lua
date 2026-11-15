--- User commands backing the keymaps in modules/home/nvf/vim/*.nix.
---
--- Lua lives in files rather than inline strings in Nix so that
--- lua-language-server can lint and complete it.

--- Apply deadnix and statix fixes to the current buffer.
---
--- nvim-lint only publishes diagnostics, it cannot provide code actions, so
--- this mirrors what a "fix all" action would do. The fixed content is applied
--- with nvim_buf_set_lines to keep the change undoable.
local function nix_fix()
  local buf = vim.api.nvim_get_current_buf()
  if vim.bo[buf].filetype ~= "nix" then
    vim.notify("NixFix: not a Nix buffer", vim.log.levels.WARN)
    return
  end

  local tmp = vim.fn.tempname() .. ".nix"
  vim.fn.writefile(vim.api.nvim_buf_get_lines(buf, 0, -1, false), tmp)

  for _, cmd in ipairs({
    { "deadnix", "--edit", "--no-underscore", tmp },
    { "statix", "fix", tmp },
  }) do
    local res = vim.system(cmd, { text = true }):wait()
    if res.code ~= 0 then
      vim.notify(("NixFix: %s failed\n%s"):format(cmd[1], res.stderr or ""), vim.log.levels.ERROR)
      vim.fn.delete(tmp)
      return
    end
  end

  local fixed = vim.fn.readfile(tmp)
  vim.fn.delete(tmp)

  if vim.deep_equal(vim.api.nvim_buf_get_lines(buf, 0, -1, false), fixed) then
    vim.notify("NixFix: nothing to fix", vim.log.levels.INFO)
    return
  end

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, fixed)
  vim.notify("NixFix: applied deadnix + statix fixes", vim.log.levels.INFO)
end

vim.api.nvim_create_user_command("NixFix", nix_fix, {
  desc = "Apply deadnix and statix fixes to the current buffer",
})

vim.api.nvim_create_user_command("NixDiagNext", function()
  vim.diagnostic.jump({ count = 1 })
end, { desc = "Go to the next diagnostic" })

vim.api.nvim_create_user_command("NixDiagPrev", function()
  vim.diagnostic.jump({ count = -1 })
end, { desc = "Go to the previous diagnostic" })

vim.api.nvim_create_user_command("NixDiagFloat", function()
  vim.diagnostic.open_float()
end, { desc = "Show diagnostics for the current line" })

--- Request code actions for the whole current line.
---
--- nixd only returns a diagnostic's quickfix when the requested range overlaps
--- the diagnostic's own range. vim.lsp.buf.code_action() sends just the cursor
--- position, so zero-width diagnostics (e.g. "expected ;") are only reachable
--- when the cursor sits exactly on the offending character. Asking for the
--- whole line makes those fixes appear from anywhere on the line.
vim.api.nvim_create_user_command("CodeActionLine", function()
  local lnum = vim.api.nvim_win_get_cursor(0)[1]
  vim.lsp.buf.code_action({
    -- mark-indexed {row, col}, 1-based row.
    range = {
      start = { lnum, 0 },
      ["end"] = { lnum + 1, 0 },
    },
  })
end, { desc = "Show code actions for the current line" })
