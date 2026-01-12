{...}: {
  programs.nvf = {
    settings.vim = {
      # snippets.luasnip.enable = true;

      autocomplete = {
        "blink-cmp" = {
          enable = true;
          setupOpts = {
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
