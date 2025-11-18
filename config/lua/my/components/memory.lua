local mem = sbar.add("item", "components.memory", {
	icon = {
		string = " ",
		color = C.base05,
	},
	label = {
		string = "0GB",
		color = C.base05,
	},
	background = { color = C.base00 },
	position = "right",
	update_freq = 3.0,
})

mem:subscribe({ "forced", "routine", "system_woke" }, function(_)
	-- Get memory pressure for system-wide memory usage
	sbar.exec(
		"memory_pressure | grep 'System-wide memory free percentage' | awk '{print $5}' | sed 's/%//'",
		function(free_percent)
			local free_pct = tonumber(free_percent) or 100
			local used_pct = 100 - free_pct

			local fg_color = C.base05
			local bg_color = C.base00
			if used_pct > 80 then
				fg_color = C.base02
				bg_color = C.base08
			elseif used_pct > 60 then
				fg_color = C.base02
				bg_color = C.base0A
			end

			mem:set({
				icon = {
					color = fg_color,
				},
				label = {
					string = string.format("%2d%%", used_pct),
					color = fg_color,
				},
				background = { color = bg_color },
			})
		end
	)
end)
