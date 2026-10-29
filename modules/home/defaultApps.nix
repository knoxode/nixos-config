{
  # Ghostty ships no MimeType declarations, so it never shows up in file
  # manager "Open With" lists. This entry fills that gap: text files open in
  # Neovim inside Ghostty, replacing the kitty-open.desktop defaults.
  xdg.desktopEntries.ghostty-nvim = {
    name = "Neovim (Ghostty)";
    comment = "Open files in Neovim inside Ghostty";
    exec = "ghostty -e nvim %F";
    mimeType = [
      "text/english"
      "text/markdown"
      "text/plain"
      "text/x-csrc"
      "text/x-c++hdr"
      "text/x-c++src"
      "text/x-c++-src"
      "text/x-java"
      "text/x-makefile"
      "text/x-python"
      "text/x-r-markdown"
      "text/x-r-source"
      "text/x-rust"
      "text/x-tex"
    ];
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = ["mupdf.desktop"];
      "image/png" = ["org.kde.gwenview.desktop"];
      "image/jpeg" = ["org.kde.gwenview.desktop"];
      "image/tiff" = ["org.kde.gwenview.desktop"];
      "text/plain" = ["ghostty-nvim.desktop"];
      "text/markdown" = ["ghostty-nvim.desktop"];
      "text/x-python" = ["ghostty-nvim.desktop"];
      "text/x-csrc" = ["ghostty-nvim.desktop"];
      "text/x-c++-src" = ["ghostty-nvim.desktop"];
      "text/x-r-source" = ["ghostty-nvim.desktop"];
      "text/x-r-markdown" = ["ghostty-nvim.desktop"];
      "text/x-java" = ["ghostty-nvim.desktop"];
      "text/x-rust" = ["ghostty-nvim.desktop"];
    };
  };
}
