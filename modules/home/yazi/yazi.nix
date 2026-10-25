{
  settings = {
    # Allow decoding arbitrarily large images (upstream default caps at 10000x10000).
    tasks.image_bound = [
      0
      0
    ];

    plugin.prepend_fetchers = [
      {
        url = "*";
        run = "git";
        group = "git";
      }
      {
        url = "*/";
        run = "git";
        group = "git";
      }
    ];
  };
}
