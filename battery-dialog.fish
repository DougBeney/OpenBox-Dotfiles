#!/usr/bin/env fish

# If charging, exit.
if test (cat /sys/class/power_supply/BAT0/status) = "Charging"
    exit
end

set -x DISPLAY :0

# Current battery percentage
set BAT (cat /sys/class/power_supply/BAT0/capacity)

function battery_prompt
    set status_id $argv[1]
    set text $argv[2]
    set icon $argv[3]

    # Exit function if user has seen this dialog
    set current_status_id (cat /tmp/battery_script_status 2> /dev/null)
    if test $status_id = $current_status_id 2> /dev/null
        return
    end

    zenity --warning \
    --text=$text \
    --icon-name=$icon
end

if test $BAT -le 5
    battery_prompt 2 "Battery is critically low!" battery-empty
    echo "2" > /tmp/battery_script_status
else if test $BAT -le 20
    battery_prompt 1 "Battery is at 20%." battery-low
    echo "1" > /tmp/battery_script_status
else
    echo "0" > /tmp/battery_script_status
end
