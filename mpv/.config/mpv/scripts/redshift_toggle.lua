-- Toggle redshift when viewing videos with mpv

if os.execute("ps -a -o comm= | grep -qFx wlsunset") ~= 0
then
	return
end
	-- mp.msg.log("info", (rs_enabled and "Dis" or "Reen") .. "abling redshift")

vo_configured = false
function vo_configured_handler(name, value)
    vo_configured = value
    if vo_configured then
        os.execute("wlsunset-control.sh disable")
    end
end

function pause_handler(name, value)
    paused = value
    if vo_configured then
        if paused then
            os.execute("wlsunset-control.sh enable")
        else
            os.execute("wlsunset-control.sh disable")
        end
    end
end

function shutdown_handler()
	if not paused and mp.get_property_bool("vo-configured")
	then
            os.execute("wlsunset-control.sh enable")
	end
end

mp.observe_property("vo-configured", "bool", vo_configured_handler)
mp.observe_property("pause", "bool", pause_handler)
mp.register_event("shutdown", shutdown_handler)
