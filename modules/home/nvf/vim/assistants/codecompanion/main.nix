{lib, ...}: let
  inherit (lib.generators) mkLuaInline;
in {
  programs.nvf.settings.vim.assistant.codecompanion-nvim = {
    enable = true;

    setupOpts = {
      interactions = {
        chat = {
          adapter = "openrouter";

          tools = {
            web_search.opts = {
              adapter = "tavily";
              opts = {
                search_depth = "basic";
                max_results = 5;
                chunks_per_source = 2;
              };
            };
            fetch_webpage.opts.adapter = "jina";
          };
        };

        inline.adapter = "openrouter_fast";
        cmd.adapter = "openrouter";
        background.adapter = "openrouter";
      };

      adapters =
        mkLuaInline
        (lib.removePrefix "return " (builtins.readFile ./adapters.lua));

      opts = {
        log_level = "DEBUG";
        send_code = true;
      };
    };
  };
}
