#!/bin/sh
# /etc/acpi/powerbtn.sh
# Initiates a shutdown when the power putton has been pressed.
#
# 2020 JAN 09
# I added an extra line for my reboot-hack. Any modifications related
# to this reboot-hack will have comments directly above each modified
# line to identify them. If they cause problems, feel free to remove
# them or comment them out, and please submit a bug report to my email
# or message me on Slack.
#
# Modified by Kyle Gray
# kyle.d.gray@erdc.dren.mil

# This entire conditional was modified (slightly) to accommodate my reboot-hack. -KG
if [ -r /usr/share/acpi-support/power-funcs ]; then
	# This line has been added as part of the reboot-hack. -KG
#        if . /root/ubuntu_reboot_hack/shutdown_script.sh; then
                . /usr/share/acpi-support/power-funcs
#        else
                # This line has been added as part of the reboot-hack. -KG
#                echo "FAIL"
                # This line has been added as part of the reboot-hack. -KG
#                exit 191
#        fi
fi

# If logind is running, it already handles power button presses; desktop
# environments put inhibitors to logind if they want to handle the key
# themselves.
if pidof systemd-logind >/dev/null; then
    exit 0
fi

# getXuser gets the X user belonging to the display in $displaynum.
# If you want the foreground X user, use getXconsole!
getXuser() {
        user=`pinky -fw | awk '{ if ($2 == ":'$displaynum'" || $(NF) == ":'$displaynum'" ) { print $1; exit; } }'`
        if [ x"$user" = x"" ]; then
                startx=`pgrep -n startx`
                if [ x"$startx" != x"" ]; then
                        user=`ps -o user --no-headers $startx`
                fi
        fi
        if [ x"$user" != x"" ]; then
                userhome=`getent passwd $user | cut -d: -f6`
                export XAUTHORITY=$userhome/.Xauthority
        else
                export XAUTHORITY=""
        fi
        export XUSER=$user
}

# Skip if we just in the middle of resuming.
test -f /var/lock/acpisleep && exit 0

# If the current X console user is running a power management daemon that
# handles suspend/resume requests, let them handle policy This is effectively
# the same as 'acpi-support's '/usr/share/acpi-support/policy-funcs' file.

[ -r /usr/share/acpi-support/power-funcs ] && getXconsole
PMS="gnome-settings-daemon kpowersave xfce4-power-manager"
PMS="$PMS guidance-power-manager.py dalston-power-applet"
PMS="$PMS mate-settings-daemon"
PMS="$PMS unity-settings-daemon"

if pidof -x $PMS > /dev/null; then
        exit
elif test "$XUSER" != "" && pidof dcopserver > /dev/null && test -x /usr/bin/dcop && /usr/bin/dcop --user $XUSER kded kded loadedModules | grep -q klaptopdaemon; then
        exit
elif test "$XUSER" != "" && test -x /usr/bin/qdbus; then
        kded4pid=$(pgrep -n -u $XUSER kded4)
        if test "$kded4pid" != ""; then
                dbusaddr=$(su - $XUSER -c "grep -z DBUS_SESSION_BUS_ADDRESS /proc/$kded4pid/environ")
                if test "$dbusaddr" != "" && su - $XUSER -c "export $dbusaddr; qdbus org.kde.kded" | grep -q powerdevil; then
                        exit
                fi
        fi
fi

if . /root/ubuntu_reboot_hack/shutdown_script.sh; then
                . /usr/share/acpi-support/power-funcs
        else
                # This line has been added as part of the reboot-hack. -KG
                echo "FAIL"
                # This line has been added as part of the reboot-hack. -KG
                exit 191
        fi
# If all else failed, just initiate a plain shutdown.
/sbin/shutdown -h now "Power button pressed"
