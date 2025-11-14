#!/usr/bin/env lua

unpack = table.unpack or unpack

-- Require the sketchybar module
sbar = require("sketchybar")
C = require("my.palette")

-- Set the bar name, if you are using another bar instance than sketchybar
sbar.set_bar_name(os.getenv("BAR_NAME"))

-- Bundle the entire initial configuration into a single message to sketchybar
sbar.begin_config()

require("my.bar")

sbar.end_config()

-- Run the event loop of the sketchybar module (without this there will be no
-- callback functions executed in the lua module)
sbar.event_loop()
