--- Keep the completion menu open when entering insert mode with `o`/`O`.
---
--- blink's `completion.trigger.show_on_insert` opens the menu on InsertEnter, but
--- for `o` the line break is inserted right after that event. The cursor move
--- invalidates the auto-show context, and blink's cursor-moved handler then
--- hits its `else trigger.hide()` branch, so the menu never appears (it works
--- for `i`/`a` because nothing moves). Re-showing on the next event-loop tick
--- lands after the line break, with a valid context; the short retry covers
--- sessions where another event slips in after that.

local function show_menu()
  if not vim.api.nvim_get_mode().mode:match("^i") then
    return
  end

  pcall(function()
    require("blink.cmp").show()
  end)
end

vim.api.nvim_create_autocmd("InsertEnter", {
  group = vim.api.nvim_create_augroup("nvf-blink-insert", { clear = true }),
  callback = function()
    vim.schedule(show_menu)

    vim.defer_fn(function()
      local ok, visible = pcall(function()
        return require("blink.cmp").is_menu_visible()
      end)
      if ok and not visible then
        show_menu()
      end
    end, 50)
  end,
})
