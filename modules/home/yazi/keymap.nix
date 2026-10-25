{
  keymap = {
    mgr.prepend_keymap = [
      {
        on = "z";
        run = "plugin zoxide";
        desc = "Jump to a directory via zoxide";
      }
      {
        on = "Z";
        run = "plugin fzf";
        desc = "Jump to a file/directory via fzf";
      }
      {
        on = "t";
        run = "tab_create --current";
        desc = "Create a new tab with CWD";
      }
      {
        on = [
          "g"
          "i"
        ];
        run = "plugin lazygit";
        desc = "run lazygit";
      }
      {
        on = "l";
        run = "plugin smart-enter";
        desc = "Enter the child directory, or open the file";
      }
    ];
    help.prepend_keymap = [
      {
        on = "f";
        run = "filter";
        desc = "Filter help items";
      }
    ];
  };
}
