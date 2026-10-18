local shared = require("shared")
-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:

hl.on("hyprland.start", function()
  hl.exec_cmd(
    "dbus-update-activation-environment --systemd "
      .. "DISPLAY HYPRLAND_INSTANCE_SIGNATURE WAYLAND_DISPLAY "
      .. "XDG_CURRENT_DESKTOP XDG_SESSION_TYPE "
      .. "&& systemctl --user stop hyprland-session.target "
      .. "&& systemctl --user start hyprland-session.target"
  )
end)

hl.on("hyprland.start", function()
  hl.exec_cmd("noctalia")
  hl.exec_cmd("DiscordCanary", { workspace = "special:apps silent" })
  hl.exec_cmd("obsidian", { workspace = "special:apps silent" })
  hl.exec_cmd("spotify", { workspace = "special:apps silent" })
end)

hl.on("hyprland.shutdown", function()
  os.execute("systemctl --user stop hyprland-session.target && sleep 0.1")
end)
