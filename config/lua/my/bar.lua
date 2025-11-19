sbar.bar({
	height = 24,
	color = C.base00,
	padding_right = 8,
	padding_left = 8,
})

sbar.default({
	updates = "when_shown",
	icon = {
		font = "Lilex Nerd Font:Regular:14.0",
		color = C.base05,
		padding_left = 6,
		padding_right = 4,
	},
	label = {
		font = "Lilex Nerd Font:Regular:14.0",
		color = C.base05,
		padding_left = 0,
		padding_right = 6,
	},
})

-- Left
require("my.components.spaces")
require("my.components.window_title")

-- Right
require("my.components.calendar")
require("my.components.battery")
require("my.components.cpu")
require("my.components.memory")
require("my.components.network")
