#!/bin/bash

# If the file is already present, delete the old one before copying the new one over

if [ -f /etc/init.d/boot_check.sh ]; then
	rm -rf /etc/init.d/boot_check.sh
fi

cp boot_check.sh /etc/init.d

if [ -f /etc/init.d/shutdown_script.sh ]; then
	rm -rf /etc/init.d/shutdown_script.sh
fi

cp shutdown_script.sh /etc/init.d

if [ -f /etc/acpi/powerbtn.sh ]; then
	rm -rf /etc/acpi/powerbtn.sh
fi

cp powerbtn.sh /etc/acpi