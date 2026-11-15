{...}: {
  programs.nvf = {
    settings.vim = {
      utility = {
        ccc.enable = false;
        vim-wakatime.enable = false;
        diffview-nvim.enable = true;
        yanky-nvim.enable = false;
        qmk-nvim.enable = false; # requires hardware specific options
        icon-picker.enable = true;
        surround.enable = true;
        leetcode-nvim.enable = false;
        multicursors.enable = true;
        smart-splits.enable = true;
        undotree.enable = true;
        nvim-biscuits.enable = false;

        motion = {
          # hop's default <leader>h collides with gitsigns' <leader>h* prefix;
          # leap covers the same use case without stealing a leader group.
          hop.enable = false;
          leap.enable = true;
          precognition.enable = true;
        };
        images = {
          image-nvim.enable = false;
          img-clip.enable = true;
        };
      };
    };
  };
}
