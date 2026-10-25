{pkgs, ...}: {
  programs.nvf.settings.vim.luaConfigRC.avanteNativeLibrary = ''
    local matches = vim.fn.globpath(
      vim.o.packpath,
      "pack/*/opt/avante-nvim/build/avante_templates.so",
      false,
      true
    )

    if #matches > 0 then
      local directory = vim.fn.fnamemodify(matches[1], ":h")
      local searchPath = directory .. "/?.so"

      if not package.cpath:find(searchPath, 1, true) then
        package.cpath = searchPath .. ";" .. package.cpath
      end
    end
  '';
}
