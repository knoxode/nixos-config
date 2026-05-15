local shared = require("shared")
-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:

hl.on("hyprland.start", function()
	hl.exec_cmd("hypridle")
	hl.exec_cmd("DiscordCanary", { workspace = "special:apps silent" })
	hl.exec_cmd("obsidian", { workspace = "special:apps silent" })
	hl.exec_cmd("spotify", { workspace = "special:apps silent" })
end)

hl.on("monitor.added", shared.restart_noctalia)
hl.on("monitor.removed", shared.restart_noctalia)
