local net = sbar.add("item", "components.network", {
	icon = {
		string = "󰛳 ",
		color = C.base05,
	},
	label = {
		string = "↓0KB ↑0KB",
		color = C.base05,
	},
	background = { color = C.base00 },
	position = "right",
	update_freq = 1.0,
})

local last_rx = 0
local last_tx = 0
local last_time = 0

net:subscribe({ "forced", "routine", "system_woke" }, function(_)
	sbar.exec("netstat -b -I en0 | grep 'en0'", function(output)
		if not output then
			return
		end

		local current_time = os.time()
		local rx = 0
		local tx = 0

		-- Parse netstat output for bytes in/out
		for line in output:gmatch("[^\r\n]+") do
			local ibytes = line:match("(%d+)%s+%d+%s+%d+%s+%d+%s+%d+%s+%d+%s+(%d+)")
			if ibytes then
				rx = tonumber(ibytes)
			end
			local obytes = line:match("%d+%s+%d+%s+%d+%s+%d+%s+%d+%s+%d+%s+(%d+)")
			if obytes then
				tx = tonumber(obytes)
			end
		end

		if last_time > 0 and current_time > last_time then
			local time_diff = current_time - last_time
			local rx_diff = rx - last_rx
			local tx_diff = tx - last_tx

			local rx_rate = rx_diff / time_diff
			local tx_rate = tx_diff / time_diff

			local rx_str = "0KB"
			local tx_str = "0KB"

			if rx_rate >= 1024 * 1024 then
				rx_str = string.format("%.1fMB", rx_rate / (1024 * 1024))
			elseif rx_rate >= 1024 then
				rx_str = string.format("%.0fKB", rx_rate / 1024)
			else
				rx_str = string.format("%.0fB", rx_rate)
			end

			if tx_rate >= 1024 * 1024 then
				tx_str = string.format("%.1fMB", tx_rate / (1024 * 1024))
			elseif tx_rate >= 1024 then
				tx_str = string.format("%.0fKB", tx_rate / 1024)
			else
				tx_str = string.format("%.0fB", tx_rate)
			end

			net:set({
				label = {
					string = string.format("↓%s ↑%s", rx_str, tx_str),
					color = C.base05,
				},
			})
		end

		last_rx = rx
		last_tx = tx
		last_time = current_time
	end)
end)
