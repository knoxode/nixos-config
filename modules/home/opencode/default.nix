{...}: {
  programs.opencode = {
    enable = true;

    settings = {
      model = "openrouter/z-ai/glm-5.3-flash";

      providers.openrouter = {
        env = ["OPENROUTER_API_KEY"];

        models = {
          "z-ai/glm-5.3-flash" = {};
          "minimax/minimax-m3.1-flash" = {};
          "deepseek/deepseek-v4-flash-0731" = {};
          "qwen/qwen3.8-27b" = {};
        };
      };
    };
  };
}
