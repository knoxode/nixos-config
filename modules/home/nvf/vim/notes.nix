{config, ...}: let
  obsidianConf =
    if config.home.username == "shaiikura"
    then {
      obsidian = {
        enable = true;
        setupOpts = {
          completion = {
            nvim_cmp = true;
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
      mind-nvim.enable = false;
      todo-comments.enable = true;
    }
    // obsidianConf;
}
