{
  programs.ghostty = {
    enable = true;

    settings = {
      ####################################
      #             Theming              #
      ####################################

      window-title-font-family = "JetBrainsMono Nerd Font Mono";

      font-family = "JetBrainsMono Nerd Font Mono";
      font-style = "SemiBold";
      font-size = 13;
      adjust-cursor-thickness = 1;

      selection-background = "dc8a78";

      window-show-tab-bar = "always";
      gtk-tabs-location = "bottom";
      gtk-titlebar-style = "tabs";
      window-theme = "ghostty";
      gtk-toolbar-style = "raised-border";
      window-titlebar-foreground = "#000000";
      window-titlebar-background = "#eba0ac";

      ####################################
      #         Nice to haves            #
      ####################################

      notify-on-command-finish = "unfocused";
      notify-on-command-finish-action = "notify";

      split-inherit-working-directory = true;
      tab-inherit-working-directory = false;
      window-inherit-working-directory = false;

      shell-integration = "detect";
      shell-integration-features = "ssh-env,cursor,sudo,title,ssh-terminfo";

      quick-terminal-position = "center";
      quick-terminal-size = "50%,50%";
      quick-terminal-animation-duration = 0;

      bell-features = "system,no-audio";
      linux-cgroup = "always";

      ####################################
      #             Keybinds             #
      ####################################

      keybind = [
        # Unbinds
        "ctrl+shift+c=unbind"
        "ctrl+shift+f=unbind"
        "ctrl+alt+arrow_left=unbind"
        "ctrl+alt+arrow_right=unbind"
        "ctrl+alt+arrow_up=unbind"
        "ctrl+alt+arrow_down=unbind"
        "ctrl+shift+e=unbind"
        "ctrl+shift+o=unbind"
        "ctrl+shift+t=unbind"
        "ctrl+shift+w=unbind"

        # Move between panes (vim-style)
        "ctrl+shift+h=goto_split:left"
        "ctrl+shift+j=goto_split:bottom"
        "ctrl+shift+k=goto_split:top"
        "ctrl+shift+l=goto_split:right"

        # Splits
        "ctrl+v=new_split:right"
        "ctrl+s=new_split:down"

        "ctrl+t=new_tab"
        "ctrl+q=close_tab"

        # Scrollback selection
        "alt+shift+h=adjust_selection:left"
        "alt+shift+j=adjust_selection:down"
        "alt+shift+k=adjust_selection:up"
        "alt+shift+l=adjust_selection:right"

        # Scrollback movement
        "ctrl+[=scroll_page_up"
        "ctrl+]=scroll_page_down"

        # Tab naming
        "ctrl+shift+c=prompt_tab_title"

        # Moving tabs
        "ctrl+shift+f=move_tab:1"
        "ctrl+shift+b=move_tab:-1"

        # Resize splits
        "ctrl+alt+h=resize_split:left,20"
        "ctrl+alt+j=resize_split:down,20"
        "ctrl+alt+k=resize_split:up,20"
        "ctrl+alt+l=resize_split:right,20"

        # Quick terminal
        "ctrl+shift+q=toggle_quick_terminal"

        # Search
        "ctrl+shift+f=start_search"
        "alt+n=navigate_search:next"
        "alt+shift+n=navigate_search:previous"
      ];
    };
  };
}
