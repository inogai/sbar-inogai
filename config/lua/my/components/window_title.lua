local M = sbar.add("item", "components.window.title", {
	padding_left = 8,
	icon = { font = { style = "Bold" } },
})

local LABEL_MAX_LENGTH = 40

local function update_window_title()
	sbar.exec("aerospace list-windows --focused --json", function(output)
		local window = output[1]
		local title = window["window-title"] or ""
		local app_name = window["app-name"] or ""

		local icon = "▎" .. app_name .. " @ "
		local label = title

		if label:len() > LABEL_MAX_LENGTH then
			label = label:sub(1, LABEL_MAX_LENGTH - 2) .. "..."
		end

		M:set({
			icon = { string = icon },
			label = { string = label },
		})
	end)
end

M:subscribe({
	"front_app_switched",
	"aerospace_workspace_change",
}, function(_)
	update_window_title()
end)

update_window_title()
