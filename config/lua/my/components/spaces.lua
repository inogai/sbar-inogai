local icons = {
	active = "󰮯 ",
	inactive = "󰝥 ",
	empty = "󰝯 ",
}

local app_icons = require("sbaf.icon_map")
local tui_app_icons = require("sbaf.tui_icon_map")
local exe = os.getenv("BAR_NAME") or "sketchybar"

local function get_app_icon(window)
	if not window then
		return app_icons["Default"]
	end

	local app_name = window["app-name"]
	local window_title = window["window-title"]

	if not app_name or app_name == "" then
		return app_icons["Default"]
	end

	if app_name == "kitty" and window_title and window_title ~= "" then
		local matched = window_title:match("> (%w+)")
		if matched then
			local tui_app = tui_app_icons[matched]
			if tui_app then
				return tui_app
			end
		end
	end

	return app_icons[app_name] or app_icons["Default"]
end

local function parse_json_apps(json_output)
	if not json_output or type(json_output) ~= "table" then
		return {}
	end

	local windows = {}
	for _, window in ipairs(json_output) do
		if window and window["app-name"] then
			table.insert(windows, window)
		end
	end
	return windows
end

local function update_space_display(space_id)
	sbar.exec("aerospace list-windows --workspace " .. space_id .. " --json", function(output)
		local apps = parse_json_apps(output)
		local app_count = #apps

		local is_active = false
		sbar.exec("aerospace list-workspaces --focused", function(focused_output)
			if focused_output and focused_output:gsub("%s+", "") == space_id then
				is_active = true
			end

			local icon = space_id
			local background = C.base00
			local foreground = C.base04
			local label = ""
			local gap = 4

			if is_active then
				background = C.base0D
				foreground = C.base00
				if app_count > 0 then
					local app_icons_str = ""
					for _, window in ipairs(apps) do
						local app_icon = get_app_icon(window)
						app_icons_str = app_icons_str .. app_icon
					end
					label = app_icons_str
				else
					gap = 0
				end
			elseif app_count > 0 then
				foreground = C.base05

				local app_icons_str = ""
				for _, window in ipairs(apps) do
					local app_icon = get_app_icon(window)
					app_icons_str = app_icons_str .. app_icon
				end
				label = app_icons_str
			else
				gap = 0
			end

			sbar.set("components.space." .. space_id, {
				icon = {
					string = icon,
					color = foreground,
					padding_right = gap,
				},
				label = { string = label, color = foreground },
				background = { color = background },
				click_script = "aerospace focus-workspace " .. space_id,
			})
		end)
	end)
end

local function create_space_items()
	sbar.exec("aerospace list-monitors", function(monitors_output)
		if not monitors_output then
			return
		end

		-- Parse monitors
		local monitors = {}
		for line in monitors_output:gmatch("[^\r\n]+") do
			local monitor_id = line:match("^(%d+)")
			if monitor_id then
				table.insert(monitors, tonumber(monitor_id))
			end
		end

		-- Create spaces for each monitor
		for _, monitor in ipairs(monitors) do
			sbar.exec("aerospace list-workspaces --monitor " .. monitor, function(workspaces_output)
				if not workspaces_output then
					return
				end

				local workspaces = {}
				for space in workspaces_output:gmatch("[^\r\n]+") do
					if space and space ~= "" then
						table.insert(workspaces, space)
					end
				end

				for _, space in ipairs(workspaces) do
					sbar.add("space", "components.space." .. space, {
						position = "left",
						space = space,
						display = monitor,
						icon = { string = space, color = C.base04 },
						label = { string = "", color = C.base04, font = "sketchybar-app-font:Regular:14.0" },
						background = { color = C.base00 },
						click_script = "aerospace workspace " .. space,
					})

					-- call `move` to ensure the order is preserved
					sbar.exec(exe .. " --move " .. "components.space." .. space .. " before components.space.watcher")

					update_space_display(space)
				end

				local move_cmd = ""

				for _, space in ipairs(workspaces) do
					move_cmd = move_cmd
						.. exe
						.. " --move components.space."
						.. space
						.. " before components.space.watcher; "
				end
				sbar.exec(move_cmd)
			end)
		end
	end)
end

local function setup_workspace_watcher()
	local watcher = sbar.add("item", "components.space.watcher", {
		width = 0,
		position = "left",
	})

	watcher:subscribe("aerospace_workspace_change", function(_)
		sbar.exec("aerospace list-monitors", function(monitors_output)
			if not monitors_output then
				return
			end

			-- Parse monitors
			local monitors = {}
			for line in monitors_output:gmatch("[^\r\n]+") do
				local monitor_id = line:match("^(%d+)")
				if monitor_id then
					table.insert(monitors, tonumber(monitor_id))
				end
			end

			-- Update spaces for each monitor
			for _, monitor in ipairs(monitors) do
				sbar.exec("aerospace list-workspaces --monitor " .. monitor, function(workspaces_output)
					if not workspaces_output then
						return
					end

					for space in workspaces_output:gmatch("[^\r\n]+") do
						if space and space ~= "" then
							update_space_display(space)
						end
					end
				end)
			end
		end)
	end)

	watcher:subscribe("space_windows_change", function(_)
		sbar.exec("aerospace list-monitors", function(monitors_output)
			if not monitors_output then
				return
			end

			-- Parse monitors
			local monitors = {}
			for line in monitors_output:gmatch("[^\r\n]+") do
				local monitor_id = line:match("^(%d+)")
				if monitor_id then
					table.insert(monitors, tonumber(monitor_id))
				end
			end

			-- Update spaces for each monitor
			for _, monitor in ipairs(monitors) do
				sbar.exec("aerospace list-workspaces --monitor " .. monitor, function(workspaces_output)
					if not workspaces_output then
						return
					end

					for space in workspaces_output:gmatch("[^\r\n]+") do
						if space and space ~= "" then
							update_space_display(space)
						end
					end
				end)
			end
		end)
	end)

	watcher:subscribe("front_app_switched", function(_)
		sbar.exec("aerospace list-monitors", function(monitors_output)
			if not monitors_output then
				return
			end

			-- Parse monitors
			local monitors = {}
			for line in monitors_output:gmatch("[^\r\n]+") do
				local monitor_id = line:match("^(%d+)")
				if monitor_id then
					table.insert(monitors, tonumber(monitor_id))
				end
			end

			-- Update spaces for each monitor
			for _, monitor in ipairs(monitors) do
				sbar.exec("aerospace list-workspaces --monitor " .. monitor, function(workspaces_output)
					if not workspaces_output then
						return
					end

					for space in workspaces_output:gmatch("[^\r\n]+") do
						if space and space ~= "" then
							update_space_display(space)
						end
					end
				end)
			end
		end)
	end)
end

create_space_items()
setup_workspace_watcher()
