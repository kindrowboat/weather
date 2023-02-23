local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty")

local function create_weather_widget(location)
    local weather_widget = wibox.widget {
        widget = wibox.widget.textbox,
    }

    awful.widget.watch("curl -s 'wttr.in/" .. location .. "?format=%c%t'", 300, function(widget, stdout)
        widget:set_text(stdout)
    end, weather_widget)

    weather_widget:connect_signal("button::press", function(_, _, _, button)
        if button == 1 then
            command = "'curl https://wttr.in/" .. location .. "'"
            -- xfce4-terminal because alacritty doesn't support startup-notification
            -- see: https://github.com/awesomeWM/awesome/issues/2517
            awful.util.spawn("xfce4-terminal -T " .. command .. " -He " .. command, {
                floating = true,
                maximized = true,
            })
        end
    end)

    return weather_widget
end

return create_weather_widget
