{...}: {
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = ["mupdf.desktop"];
      "image/png" = ["org.kde.gwenview.desktop"];
      "image/jpeg" = ["org.kde.gwenview.desktop"];
      "image/tiff" = ["org.kde.gwenview.desktop"];
      "text/plain" = ["kitty-open.desktop"];
      "text/markdown" = ["kitty-open.desktop"];
      "text/x-python" = ["kitty-open.desktop"];
      "text/x-csrc" = ["kitty-open.desktop"];
      "text/x-c++-src" = ["kitty-open.desktop"];
      "text/x-r-source" = ["kitty-open.desktop"];
      "text/x-r-markdown" = ["kitty-open.desktop"];
      "text/x-java" = ["kitty-open.desktop"];
      "text/x-rust" = ["kitty-open.desktop"];
    };
  };
}
