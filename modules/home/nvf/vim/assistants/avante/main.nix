{pkgs, ...}: let
  mkProvider = model: {
    __inherited_from = "openai";
    endpoint = "https://openrouter.ai/api/v1";
    api_key_name = "OPENROUTER_API_KEY";
    inherit model;
    timeout = 60000;
  };
in {
  imports = [./patch.nix];
  programs.nvf.settings = {
    vim = {
      startPlugins = [
        pkgs.vimPlugins.mega-logging
        pkgs.vimPlugins.mega-cmdparse
      ];

      assistant.avante-nvim = {
        enable = true;

        setupOpts = {
          provider = "openrouter";
          auto_suggestions_provider = "openrouter_fast";

          providers = {
            openrouter = mkProvider "z-ai/glm-5.3-flash";
            openrouter_fast = mkProvider "minimax/minimax-m3.1-flash";
            openrouter_deepseek = mkProvider "deepseek/deepseek-v4-flash-0731";
            openrouter_reasoning = mkProvider "qwen/qwen3.8-27b";
          };

          behaviour = {
            auto_suggestions = false;
            auto_apply_diff_after_generation = false;
          };
        };
      };
    };
  };
}
