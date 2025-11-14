local cal = sbar.add("item", "components.calendar", {
	label = {
		string = os.date("URA 99 UND 99:99"),
	},
	position = "right",
	update_freq = 20,
	click_script = "open -a 'Calendar'",
})

cal:subscribe({ "forced", "routine", "system_woke" }, function(_)
	cal:set({
		label = os.date("%a %d %b %H:%M"),
	})
end)
