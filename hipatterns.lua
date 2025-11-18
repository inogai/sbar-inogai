-- Setup mini.hipatterns for highlighting C.baseXX and hex colors

local hipatterns = require("mini.hipatterns")

local colors = {
	base00 = "#181818",
	base01 = "#202020",
	base02 = "#333333",
	base03 = "#444444",
	base04 = "#777777",
	base05 = "#cccccc",
	base06 = "#dddddd",
	base07 = "#ffffff",
	base08 = "#ff8787",
	base09 = "#f3a580",
	base0A = "#f6c177",
	base0B = "#74ccaa",
	base0C = "#5fb5be",
	base0D = "#7098d4",
	base0E = "#ed9cc2",
	base0F = "#a0a5d6",
}

hipatterns.setup({
	highlighters = {
		oxargb_color = {
			pattern = "0xff%x%x%x%x%x%x",
			group = function(_, match)
				return hipatterns.compute_hex_color_group("#" .. match:sub(5), "bg")
			end,
		},
		base_color = {
			pattern = "base%x%x",
			group = function(_, match)
				local hex = colors[match]
				if hex then
					return hipatterns.compute_hex_color_group(hex, "bg")
				end
			end,
		},
	},
})
