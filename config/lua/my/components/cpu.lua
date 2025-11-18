local cpu = sbar.add("item", "components.cpu", {
	icon = {
		string = "󰍛 ",
		color = C.base05,
	},
	label = {
		string = "0%",
		color = C.base05,
	},
	background = { color = C.base00 },
	position = "right",
	update_freq = 2.0,
})

cpu:subscribe({ "forced", "routine", "system_woke" }, function(_)
	sbar.exec("top -l 1 -n 0 | grep 'CPU usage' | awk '{print $3}' | sed 's/%//'", function(output)
		local cpu_usage = tonumber(output) or 0
		local fg_color = C.base05
		local bg_color = C.base00

		if cpu_usage > 80 then
			fg_color = C.base02
			bg_color = C.base08
		elseif cpu_usage > 50 then
			fg_color = C.base02
			bg_color = C.base0A
		end

		cpu:set({
			icon = {
				color = fg_color,
			},
			label = {
				string = string.format("%02.0f%%", cpu_usage),
				color = fg_color,
			},
			background = { color = bg_color },
		})
	end)
end)
