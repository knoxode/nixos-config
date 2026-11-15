{...}: {
  programs.nvf = {
    settings.vim = {
      # snippets.luasnip.enable = true;

      extraLuaFiles = [../lua/blink-insert.lua];

      autocomplete = {
        "blink-cmp" = {
          enable = true;
          setupOpts = {
            completion.trigger.show_on_insert = true;
            signature = {
              enabled = true;
            };
            cmdline = {
              keymap = {
                preset = "super-tab"; # allowed values: "none","super-tab","enter",...
              };
            };
          };

          "friendly-snippets" = {
            enable = true;
          };
        };
      };
    };
  };
}
