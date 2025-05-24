{ pkgs, ... }: {
  home.packages = with pkgs; [ pyprland ];

  home.file.".config/hypr/pyprland.toml".text = ''
    [pyprland]
    plugins = [
      "scratchpads",
    ]

    [scratchpads.term]
    animation = "fromTop"
    command = "kitty --class kitty-dropterm"
    class = "kitty-dropterm"
    size = "75% 75%"
    max_size = "1920px 100%"
    position = "150px 150px"
    
    [scratchpads.spotify]
    animation = "fromTop"
    command = "spotify --enable-features=UseOzonePlatform --ozone-platform=wayland"
    class = "spotify"
    size = "75% 75%"
    max_size = "1920px 100%"
    position = "150px 150px"
    lazy = true
    
    [scratchpads.beeper]
    process_tracking = false
    animation = "fromTop"
    command = "beeper"
    class = "BeeperTexts"
    size = "75% 75%"
    max_size = "1920px 100%"
    position = "150px 150px"
    lazy = true
    
    [scratchpads.discord]
    process_tracking = false
    animation = "fromTop"
    command = "discordcanary --start-minimized"
    class = "discord"
    initialClass = "discord"
    size = "75% 75%"
    max_size = "1920px 100%"
    position = "150px 150px"
    lazy = false
    
    [scratchpads.obsidian]
    animation = "fromTop"
    command = "obsidian"
    class = "obsidian"
    size = "75% 75%"
    max_size = "1920px 100%"
    position = "150px 150px"
    lazy = true
  '';
}
