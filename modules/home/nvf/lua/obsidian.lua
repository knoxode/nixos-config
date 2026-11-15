--- Create an Obsidian note in a folder chosen from the vault.
---
--- `:Obsidian new` accepts a path (`DPhil/Seminars/Foo`), but you have to
--- remember and type it. This prompts for the folder with the fuzzy picker and
--- then for the title, so a meeting/seminar note can be created from anywhere.
--- The folder used last is offered first, so repeat notes are two <cr> presses.

local last_folder = nil

--- obsidian.nvim is lazy-loaded, so the `Obsidian` global does not exist until
--- the plugin is triggered. nvf loads plugins through lz.n.
---@return boolean
local function ensure_obsidian()
  if _G.Obsidian then
    return true
  end

  local ok, lzn = pcall(require, "lz.n")
  if ok and type(lzn.trigger_load) == "function" then
    pcall(lzn.trigger_load, "obsidian-nvim")
  end

  return _G.Obsidian ~= nil
end

---@return string|?
local function vault_root()
  if not ensure_obsidian() then
    return nil
  end

  local workspace = Obsidian.workspaces and Obsidian.workspaces[1]
  local root = workspace and workspace.path or Obsidian.dir
  return root and tostring(root)
end

---@param root string
---@return string[]
local function vault_dirs(root)
  local dirs = {}
  for name, kind in vim.fs.dir(root, { depth = 4 }) do
    if kind == "directory" and not name:match("^%.") then
      dirs[#dirs + 1] = name
    end
  end
  table.sort(dirs)

  if last_folder then
    for i, dir in ipairs(dirs) do
      if dir == last_folder then
        table.remove(dirs, i)
        break
      end
    end
    table.insert(dirs, 1, last_folder)
  end

  return dirs
end

local function new_note_in_folder()
  local root = vault_root()
  if not root then
    vim.notify("ObsidianNewInFolder: could not determine the vault root", vim.log.levels.ERROR)
    return
  end

  vim.ui.select(vault_dirs(root), {
    prompt = "New note in folder",
    format_item = function(dir)
      return dir == "" and "(vault root)" or dir
    end,
  }, function(folder)
    if folder == nil then
      return
    end
    last_folder = folder

    vim.ui.input({ prompt = "Note title: " }, function(title)
      if title == nil or vim.trim(title) == "" then
        return
      end

      local id = folder == "" and title or (folder .. "/" .. title)
      require("obsidian.actions").new(id, function(note)
        note:open({ sync = true })
      end)
    end)
  end)
end

vim.api.nvim_create_user_command("ObsidianNewInFolder", new_note_in_folder, {
  desc = "Create an Obsidian note in a chosen folder",
})
