{
  config,
  lib,
  ...
}: {
  config = lib.mkMerge [
    {
      programs.nvf.settings.vim.notes =
        {
          neorg.enable = false;
          orgmode.enable = false;
          todo-comments.enable = true;
        }
        // lib.optionalAttrs config.alexos.user.obsidian.enable {
          obsidian = {
            enable = true;
            setupOpts = {
              legacy_commands = false;
              ui = {
                enable = false;
              };
              picker = {
                name = "telescope.nvim";
              };

              # New notes are created in the directory of the note being edited,
              # so creating one while in DPhil/Seminars/ keeps it there.
              # (`notes_subdir` would flatten everything into one directory; it
              # is only consulted when this is "notes_subdir".)
              new_notes_location = "current_dir";
              # Readable title-based filenames instead of the default zettel IDs
              # (e.g. 1770032067-USPT.md). This is a reference to an
              # obsidian.nvim function, not inline logic: setupOpts only accepts
              # a Lua value here, so it cannot live in modules/home/nvf/lua.
              note_id_func = lib.generators.mkLuaInline ''require("obsidian.builtin").title_id'';

              daily_notes = {
                folder = "Daily Notes";
                date_format = "%Y-%m-%d";
              };
              templates.folder = "Templates";
              attachments.folder = "attachments";

              # Completion comes from obsidian.nvim's built-in obsidian-ls LSP
              # server since v3; `completion.blink` was removed upstream.
              workspaces = [
                {
                  name = "second_brain";
                  path = "${config.home.homeDirectory}/Documents/syncthing/obsidian/second_brain/";
                }
              ];
            };
          };
        };
    }

    (lib.mkIf config.alexos.user.obsidian.enable {
      programs.nvf.settings.vim.extraLuaFiles = [../lua/obsidian.lua];

      programs.nvf.settings.vim.keymaps = [
        {
          key = "<leader>oo";
          mode = ["n"];
          action = "<cmd>Obsidian open<cr>";
          desc = "Open Obsidian note under cursor";
        }
        {
          key = "<leader>off";
          mode = ["n"];
          action = "<cmd>Obsidian quick_switch<cr>";
          desc = "Obsidian - Fuzzy Find Files";
        }
        {
          key = "<leader>ofg";
          mode = ["n"];
          action = "<cmd>Obsidian search<cr>";
          desc = "Search Obsidian vault using fuzzy finder";
        }
        {
          key = "<leader>on";
          mode = ["n"];
          action = "<cmd>ObsidianNewInFolder<cr>";
          desc = "New Obsidian note in a chosen folder";
        }
        {
          key = "<leader>oc";
          mode = ["n"];
          action = "<cmd>Obsidian new<cr>";
          desc = "New Obsidian note in the current directory";
        }
        {
          key = "<leader>ob";
          mode = ["n"];
          action = "<cmd>ObsidianBacklinks<cr>";
          desc = " Obsidian: Show backlinks";
        }
        {
          key = "<leader>ot";
          mode = ["n"];
          action = "<cmd>ObsidianToday<cr>";
          desc = " Obsidian: Open today's note";
        }
        {
          key = "<leader>opi";
          mode = ["n"];
          action = "<cmd>ObsidianPasteImg<cr>";
          desc = " Obsidian: Paste Image from Clipboard (saved into vault)";
        }
      ];
    })
  ];
}
