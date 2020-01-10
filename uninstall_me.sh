#!/bin/bash

# Look for all files created by this program and remove them

if [ -d /etc/reboot_hack ]; then
	rm -rf /etc/reboot_hack
fi

if [ -f /etc/rc5.d/S99reboot_hack ]; then
	rm -rf /etc/rc5.d/S99reboot_hack
fi

if [ -f /etc/init.d/reboot_hack ]; then
	rm -rf /etc/init.d/reboot_hack
fi

if [ -f /bin/boot_check ]; then
	rm -rf /bin/boot_check
fi

if [ -f /bin/log_shutdown_state ]; then
	rm -rf /bin/log_shutdown_state
fi

# Restore powerbtn.sh from backup
if [ -f /etc/acpi/powerbtn.sh.bak ]; then
	mv /etc/acpi/powerbtn.sh.bak /etc/acpi/powerbtn.sh
fi
