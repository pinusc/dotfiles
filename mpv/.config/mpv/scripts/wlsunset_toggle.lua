-- Toggle redshift when viewing videos with mpv

if os.execute("ps -a -o comm= | grep -qFx redshift") ~= 0
then
	return
end

-- Consider that redshift is enabled when starting
rs_enabled = true

function rs_toggle()
	os.execute("pid=$(ps -a -o comm=,pid= | sed -n 's#^redshift[[:blank:]]\\{1,\\}##p'); [ $pid ] && kill -USR1 $pid")
	mp.msg.log("info", (rs_enabled and "Dis" or "Reen") .. "abling redshift")
	rs_enabled = not rs_enabled
end

vo_configured = false
function vo_configured_handler(name, value)
	vo_configured = value
	if value == rs_enabled
	then
		rs_toggle()
	end
end

function pause_handler(name, value)
	paused = value
	if vo_configured and value ~= rs_enabled
	then
		rs_toggle()
	end
end

function shutdown_handler()
	if not paused and mp.get_property_bool("vo-configured")
	then
		rs_toggle()
	end
end

mp.observe_property("vo-configured", "bool", vo_configured_handler)
mp.observe_property("pause", "bool", pause_handler)
mp.register_event("shutdown", shutdown_handler)
