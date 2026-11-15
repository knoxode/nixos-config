--- Open :help in a floating window instead of a split.
---
--- Neovim always opens help in a split. This converts the help window into a
--- centred float and binds q to close it. Running :help again while the float
--- is open reuses the existing help window, so it stays a single float.

local function is_floating(win)
  return vim.api.nvim_win_get_config(win).relative ~= ""
end

---@param buf integer
---@return integer
local function float_help(buf)
  local width = math.min(120, math.floor(vim.o.columns * 0.8))
  local height = math.min(40, math.floor(vim.o.lines * 0.8))

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    border = "rounded",
    style = "minimal",
    title = " help ",
    title_pos = "center",
  })

  -- Set the mapping after the :help command finishes; help re-edits its buffer,
  -- which wipes mappings set during BufWinEnter.
  vim.schedule(function()
    vim.keymap.set("n", "q", "<cmd>close<CR>", {
      buffer = buf,
      desc = "Close help window",
    })
  end)

  return win
end

vim.api.nvim_create_autocmd("BufWinEnter", {
  group = vim.api.nvim_create_augroup("nvf-floating-help", { clear = true }),
  callback = function(args)
    if vim.bo[args.buf].buftype ~= "help" then
      return
    end

    local win = vim.api.nvim_get_current_win()
    if is_floating(win) then
      return
    end

    float_help(args.buf)
    vim.api.nvim_win_close(win, false)
  end,
})
