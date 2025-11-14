local icons = {
	charging = "󰂄",
	full = "󰁹",
	high = "󰂁",
	medium = "󰁾",
	low = "󰁺",
	critical = "󱃍",
}

local function get_battery_display(charge, is_charging)
	if is_charging then
		return icons.charging, C.base00, C.base0B
	elseif charge > 80 then
		return icons.full, C.base05, C.base00
	elseif charge > 60 then
		return icons.high, C.base05, C.base00
	elseif charge > 40 then
		return icons.medium, C.base05, C.base00
	elseif charge > 20 then
		return icons.low, C.base05, C.base00
	else
		return icons.critical, C.base02, C.base08
	end
end

local battery = sbar.add("item", "components.battery", {
	position = "right",
	icon = {
		string = icons.critical,
	},
	label = {
		string = "??%",
	},
	background = { color = C.base00 },
	update_freq = 60,
})

battery:subscribe({ "routine", "power_source_change", "system_woke" }, function(_)
	sbar.exec("pmset -g batt", function(batt_info)
		local found, _, charge = batt_info:find("(%d+)%%")
		if not found then
			return
		end

		charge = tonumber(charge)
		local is_charging = batt_info:find("AC Power") ~= nil

		local icon, fg_color, bg_color = get_battery_display(charge, is_charging)

		battery:set({
			icon = { string = icon, color = fg_color },
			label = { string = string.format("%d%%", charge), color = fg_color },
			background = { color = bg_color },
		})
	end)
end)
