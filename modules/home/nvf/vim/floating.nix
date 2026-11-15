{...}: {
  programs.nvf.settings.vim = {
    # Lua lives in modules/home/nvf/lua; see its README.
    extraLuaFiles = [../lua/floating-help.lua];
  };
}
