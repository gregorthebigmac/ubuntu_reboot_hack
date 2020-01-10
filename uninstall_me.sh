#!/bin/bash

# Look for all files created by this program and remove them
if [ -d /etc/reboot_hack ]; then
	rm -rf /etc/reboot_hack
fi

# Restore powerbtn.sh from backup
if [ -f /etc/acpi/powerbtn.sh.bak ]; then
	mv /etc/acpi/powerbtn.sh.bak /etc/acpi/powerbtn.sh
fi

# All of these run without checks, because the -f fails if the link is broken.
echo -n "Removing /bin/boot_check... "
if rm -rf /bin/boot_check; then
	echo "[OK]"
else echo "[FAIL]"
fi

echo -n "Removing /bin/log_shutdown_state... "
if rm -rf /bin/log_shutdown_state; then
	echo "[OK]"
else echo "[FAIL]"
fi

echo -n "Removing /etc/init.d/reboot_hack... "
if rm -rf /etc/init.d/reboot_hack; then
	echo "[OK]"
else echo "[FAIL]"
fi

echo -n "Removing /etc/rc5.d/S99reboot_hack... "
if rm -rf /etc/rc5.d/S99reboot_hack; then
	echo "[OK]"
else echo "[FAIL]"
fi
