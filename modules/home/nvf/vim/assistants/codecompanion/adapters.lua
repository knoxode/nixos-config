local adapters = require("codecompanion.adapters")

local function openrouter(model)
  return function()
    return adapters.extend("openrouter", {
      schema = {
        model = {
          default = model,
        },
        temperature = {
          default = 0.2,
        },
      },
    })
  end
end

return {
  http = {
    openrouter = openrouter("z-ai/glm-5.3-flash"),
    openrouter_fast = openrouter("minimax/minimax-m3.1-flash"),
    openrouter_deepseek = openrouter("deepseek/deepseek-v4-flash-0731"),
    openrouter_reasoning = openrouter("qwen/qwen3.8-27b"),

    extend = {
      jina = {
        env = {
          api_key = "JINA_API_KEY",
        },
      },
    },
  },
}
