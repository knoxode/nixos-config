{pkgs, ...}: {
  programs.nvf.settings.vim = {
    # deadnix/statix are wired into nvim-lint by nvf, which only publishes
    # diagnostics and cannot offer code actions. Make the binaries available on
    # PATH so the :NixFix command can apply their fixes.
    extraPackages = [pkgs.deadnix pkgs.statix];

    extraLuaFiles = [../lua/nvim-commands.lua];

    keymaps = [
      {
        key = "<leader>nf";
        mode = ["n"];
        action = "<cmd>NixFix<CR>";
        desc = "Apply nix lint fixes (deadnix + statix)";
      }
    ];
  };
}
