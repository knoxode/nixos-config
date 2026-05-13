local shared = require("shared")

local last_on_battery = nil

local function apply_battery_optimisations(on_battery)
	if on_battery == last_on_battery then
		return
	end

	last_on_battery = on_battery

	if on_battery then
		hl.config({
			decoration = {
				blur = {
					enabled = false,
				},
				shadow = {
					enabled = false,
				},
			},
		})
	else
		hl.config({
			decoration = {
				blur = {
					enabled = true,
					size = 3,
					passes = 1,
					vibrancy = 0.1696,
				},
				shadow = {
					enabled = true,
					range = 4,
					render_power = 3,
					color = 0xee1a1a1a,
				},
			},
		})
	end
end

-- hl.on("hyprland.start", function()
-- 	apply_battery_optimisations(shared.on_battery())
--
-- 	hl.timer(function()
-- 		apply_battery_optimisations(shared.on_battery())
-- 	end, {
-- 		timeout = 5000,
-- 		type = "repeat",
-- 	})
-- end)

hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 11,

		border_size = 2,

		col = {
			active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
			inactive_border = "rgba(595959aa)",
		},

		-- Set to true to enable resizing windows by clicking and dragging on borders and gaps
		resize_on_border = false,

		-- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
		allow_tearing = false,

		layout = "dwindle",
	},

	decoration = {
		rounding = 20,
		rounding_power = 6,
		active_opacity = 0.8,
		inactive_opacity = 0.8,
		fullscreen_opacity = 0.9,
	},
	animations = {
		enabled = true,
	},
})

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- Default springs
hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })
