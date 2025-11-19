local M = sbar.add("item", "components.window.title", {
	padding_left = 8,
})

local function update_window_title()
	sbar.exec("aerospace list-windows --focused --json", function(output)
		local window = output[1]
		local title = window["window-title"] or ""

		M:set({ label = { string = title } })
	end)
end

M:subscribe("front_app_switched", function(_)
	update_window_title()
end)

M:subscribe("aerospace_window_change", function(_)
	update_window_title()
end)

update_window_title()
