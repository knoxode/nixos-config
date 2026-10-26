-- Template / Xwayland tweak
hl.window_rule({
  name = "Resolve blur fix",
  match = {
    class = "^(\\bresolve\\b)$",
    xwayland = true,
  },

  no_blur = true,
})

-- Winboat rules
hl.window_rule({
  name = "Winboat",
  match = {
    class = "^winboat.*$",
    xwayland = true,
  },

  suppress_event = "fullscreen maximize activatefocus",
  no_initial_focus = true,
  no_anim = true,
  no_shadow = true,
  no_blur = true,
  xray = false,
  opaque = true,
  no_dim = true,
  force_rgbx = true,
})

hl.window_rule({
  name = "Qalculate",
  match = {
    class = "io.github.Qalculate.qalculate-qt",
  },

  float = true,
  --pin = true,
  opacity = 0.8,
  no_blur = true,
  pin = true,
  focus_on_activate = true,

  size = {
    "monitor_w * 0.25",
    "monitor_h * 0.90",
  },

  move = {
    "monitor_w - (monitor_w * 0.25) - 11",
    "monitor_h * 0.05",
  },
})

hl.window_rule({
  name = "Noctalia Settings",
  match = {
    initial_title = "Noctalia Settings",
  },

  float = true,
  --pin = true,
  opacity = 0.8,
  no_blur = true,
  center = true,
  focus_on_activate = true,

  size = {
    "monitor_w * 0.75",
    "monitor_h * 0.75",
  },
})

hl.window_rule({
  name = "Select what to share",
  match = {
    initial_title = "Select what to share",
  },

  float = true,
  --pin = true,
  opacity = 0.8,
  no_blur = true,
  center = true,
  focus_on_activate = true,

  size = {
    "monitor_w * 0.50",
    "monitor_h * 0.50",
  },
})

hl.window_rule({
  name = "File manager tag",
  match = {
    class = "^([Tt]hunar|org.gnome.Nautilus|[Pp]cmanfm-qt)$",
  },

  tag = "+file-manager",
})

hl.window_rule({
  name = "Terminal tag",
  match = {
    class = "^(com.mitchellh.ghostty|org.wezfurlong.wezterm|Alacritty|kitty|kitty-dropterm)$",
  },

  tag = "+terminal",
})

hl.window_rule({
  name = "Chat float",
  match = {
    class = "^(discord-canary|obsidian|Spotify|Texts)$",
  },

  no_initial_focus = true,
  suppress_event = "fullscreen, maximize, activate, activatefocus, fullscreenoutput",
  workspace = "special:apps",
  opacity = "0.7 override 0.7 override 0.7 override",
})

hl.window_rule({
  name = "Kitty dropterm",
  match = {
    class = "^(kitty)$",
    workspace = "special:terminal",
  },

  float = true,
  center = true,
  border_size = 0,
  no_blur = true,
  size = {
    "monitor_w * 0.90",
    "monitor_h * 0.40",
  },
  suppress_event = "fullscreen maximize",
  opacity = "0.7 override 0.7 override",
})

-- Snapgene rule
hl.window_rule({
  name = "SnapGene dialog",
  match = {
    class = "^SnapGene$",
    title = "^SnapGene$",
    modal = true,
  },

  center = true,
  size = {
    "monitor_w * 0.50",
    "monitor_h * 0.50",
  },
})

-- Fiji is multi-window (main window plus each image window); float all of
-- them. The file chooser is a separate XWayland client with class "Java".
hl.window_rule({
  name = "Fiji float",
  match = {
    class = "^(fiji-Main|Java)$",
  },

  float = true,
})

-- Fiji's GTK file chooser: centered, sized as a square at half the monitor
-- width (both axes derive from monitor_w so the dialog stays square).
hl.window_rule({
  name = "Fiji file chooser",
  match = {
    class = "^(Java)$",
    initial_title = "^(Choose a file)$",
  },

  center = true,
  size = {
    "monitor_w * 0.50",
    "monitor_w * 0.50",
  },
})

hl.window_rule({
  name = "youtube-idle-inhibit",
  match = {
    class = "firefox.*",
    title = ".*YouTube.*",
  },

  border_color = {
    colors = {
      "rgb(A020F0)", -- Purple
      "rgb(DC143C)", -- Crimson
      "rgb(FF3535)", -- Bright red
    },
    angle = 45,
  },
  idle_inhibit = "focus",
})

hl.window_rule({
  name = "whatsapp-border",
  match = {
    class = "firefox.*",
    title = ".*WhatsApp.*",
  },

  border_color = {
    colors = {
      "rgb(25D366)", -- WhatsApp green
      "rgb(00C9A7)", -- Teal
      "rgb(00FF88)", -- Neon green
      "rgb(25D366)", -- Back to green
    },
    angle = 45,
  },
})

hl.window_rule({
  name = "Browser tag",
  match = {
    class = "^(Brave-browser(-beta|-dev|-unstable)?|[Ff]irefox-nightly|[Ff]irefox|org.mozilla.firefox|[Ff]irefox-esr|[Gg]oogle-chrome(-beta|-dev|-unstable)?|[Tt]horium-browser|[Cc]achy-browser)$",
  },

  tag = "+browser",
})

hl.window_rule({
  name = "Projects tag",
  match = {
    class = "^(codium|codium-url-handler|VSCodium|VSCode|code-url-handler)$",
  },

  tag = "+projects",
})

hl.window_rule({
  name = "IM tag",
  match = {
    class = "^([Dd]iscord|[Ww]ebCord|[Vv]esktop|[Ff]erdium|[Ww]hatsapp-for-linux|org.telegram.desktop|io.github.tdesktop_x64.TDesktop|teams-for-linux)$",
  },

  tag = "+im",
})

hl.window_rule({
  name = "Games tag",
  match = {
    class = "^(gamescope|steam_app_\\d+)$",
  },

  tag = "+games",
})

hl.window_rule({
  name = "Gamestore tag",
  match = {
    class = "^([Ss]team|com.heroicgameslauncher.hgl)$",
  },

  tag = "+gamestore",
})

hl.window_rule({
  name = "Lutris gamestore tag",
  match = {
    title = "^([Ll]utris)$",
  },

  tag = "+gamestore",
})

hl.window_rule({
  name = "Settings tag",
  match = {
    class = "^(gnome-disks|wihotspot(-gui)?|[Rr]ofi|file-roller|org.gnome.FileRoller|nm-applet|nm-connection-editor|blueman-manager|pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol|nwg-look|qt5ct|qt6ct|[Yy]ad|xdg-desktop-portal-gtk|.blueman-manager-wrapped|nwg-displays)$",
  },

  tag = "+settings",
})

hl.window_rule({
  name = "PiP move",
  match = {
    title = "^(Picture-in-Picture)$",
  },

  move = "72% 7%",
})

hl.window_rule({
  name = "Waypaper float",
  match = {
    class = "^([Ww]aypaper)$",
  },

  float = true,
})

hl.window_rule({
  name = "Video player no opacity",
  match = {
    class = "^(org.jellyfin.JellyfinDesktop|tv.plex.Plex)$",
  },

  float = true,
  opacity = "1.0 override 1.0 override 1.0 override",
})

hl.window_rule({
  name = "Pavucontrol center",
  match = {
    class = "^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$",
  },

  center = true,
})

hl.window_rule({
  name = "Thunar dialogs",
  match = {
    class = "^([Tt]hunar)$",
    title = "negative:(.*[Tt]hunar.*)",
  },

  center = true,
  float = true,
})

hl.window_rule({
  name = "Authentication dialogs",
  match = {
    title = "^(Authentication Required)$",
  },

  center = true,
  float = true,
})

hl.window_rule({
  -- Inhibit idle whenever any window is fullscreen.
  name = "Idle inhibit fullscreen",
  match = {
    class = "^(.*)$",
  },

  idle_inhibit = "fullscreen",
})

hl.window_rule({
  name = "Settings float",
  match = {
    tag = "settings",
  },

  float = true,
  center = true,
  size = {
    "monitor_w * 0.70",
    "monitor_h * 0.70",
  },
  opacity = "0.8 0.7",
})

hl.window_rule({
  name = "Inkscape",
  match = {
    class = "org.inkscape.Inkscape",
  },

  opacity = "1.0 override 1.0 override 1.0 override",
})

hl.window_rule({
  name = "Ferdium",
  match = {
    class = "^([Ff]erdium)$",
  },

  float = true,
  size = {
    "monitor_w * 0.60",
    "monitor_h * 0.70",
  },
})

hl.window_rule({
  name = "PiP",
  match = {
    title = "^(Picture-in-Picture)$",
  },

  float = true,
  pin = true,
  keep_aspect_ratio = true,
  opacity = "0.95 0.75",
})

hl.window_rule({
  name = "Media float",
  match = {
    class = "^(mpv|com.github.rafostar.Clapper)$",
  },

  float = true,
})

hl.window_rule({
  name = "Codium dialogs",
  match = {
    class = "(^codium|codium-url-handler|VSCodium)",
    title = "negative:(.*codium.*|.*VSCodium.*)",
  },

  float = true,
})

hl.window_rule({
  name = "Heroic dialogs",
  match = {
    class = "^(com.heroicgameslauncher.hgl)$",
    title = "negative:(Heroic Games Launcher)",
  },

  float = true,
})

hl.window_rule({
  name = "Steam dialogs",
  match = {
    class = "^([Ss]team)$",
    title = "negative:^([Ss]team)$",
  },

  float = true,
})

hl.window_rule({
  name = "Workspace dialogs",
  match = {
    initial_title = "(Add Folder to Workspace|Open Files|wants to save)",
  },

  float = true,
})

hl.window_rule({
  name = "Workspace dialog sizing",
  match = {
    initial_title = "(Add Folder to Workspace|Open Files)",
  },

  size = {
    "monitor_w * 0.70",
    "monitor_h * 0.60",
  },
})

hl.window_rule({
  name = "Share picker",
  match = {
    initial_title = "(Select what to share)",
  },

  pin = true,
})

hl.window_rule({
  name = "Browser opacity",
  match = {
    tag = "browser",
  },

  opacity = "1.0 override 1.0 override 1.0 override",
})

hl.window_rule({
  name = "Projects opacity",
  match = {
    tag = "projects",
  },

  opacity = "0.9 0.8",
})

hl.window_rule({
  name = "IM opacity",
  match = {
    tag = "im",
  },

  opacity = "0.94 0.86",
})

hl.window_rule({
  name = "File manager opacity",
  match = {
    tag = "file-manager",
  },

  opacity = "0.9 0.8",
})

hl.window_rule({
  name = "Terminal opacity",
  match = {
    tag = "terminal",
  },

  opacity = "0.8 override 0.7 override 0.8 override",
})

hl.window_rule({
  name = "Editor opacity",
  match = {
    class = "^(gedit|org.gnome.TextEditor|mousepad)$",
  },

  opacity = "0.8 0.7",
})

hl.window_rule({
  name = "Seahorse opacity",
  match = {
    class = "^(seahorse)$",
  },

  opacity = "0.9 0.8",
})

hl.window_rule({
  name = "Games fullscreen",
  match = {
    tag = "games",
  },

  no_blur = true,
  fullscreen = true,
})

hl.window_rule({
  -- Fix some dragging issues with XWayland
  name = "fix-xwayland-drags",
  match = {
    class = "^$",
    title = "^$",
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false,
  },

  no_focus = true,
})
