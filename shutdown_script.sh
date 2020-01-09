#!/bin/bash

echo -n "Writing ACPI-SHUTDOWN to file /root/ubuntu_reboot_hack/last_shutdown.stat... "
if echo "ACPI-SHUTDOWN" > /root/ubuntu_reboot_hack/last_shutdown.stat; then
	echo "[OK]"
else
	echo "[FAIL]"
	exit 99
fi
