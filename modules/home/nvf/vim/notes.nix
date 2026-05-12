{config, ...}: let
  obsidianConf =
    if config.home.username == "shaiikura"
    then {
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

          completion = {
            blink.cmp = true;
          };
          workspaces = [
            {
              name = "second_brain";
              path = "/home/shaiikura/Documents/syncthing/obsidian/second_brain/";
            }
          ];
        };
      };
    }
    else {};
in {
  programs.nvf.settings.vim.notes =
    {
      neorg.enable = false;
      orgmode.enable = false;
      todo-comments.enable = true;
    }
    // obsidianConf;
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
      action = "<cmd>Obsidian new<cr>";
      desc = "New Obsidian note";
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
}
