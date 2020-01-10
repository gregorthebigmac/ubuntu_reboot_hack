#!/bin/bash

# If the file is already present, delete the old one before copying the new one over

# Does the "program files" dir exist? If not, make it.
if [ ! -d /etc/reboot_hack ]; then
	mkdir /etc/reboot_hack
fi

# Copying over the "program files" from the repo to /etc/reboot_hack dir on the FS.
if [ -f /etc/reboot_hack/boot_check ]; then
	rm -rf /etc/reboot_hack/boot_check
fi
cp bin/boot_check /etc/reboot_hack/boot_check

if [ -f /etc/reboot_hack/log_shutdown_state ]; then
	rm -rf /etc/reboot_hack/log_shutdown_state
fi
cp bin/log_shutdown_state /etc/reboot_hack/log_shutdown_state

if [ -f /etc/reboot_hack/reboot_hack ]; then
	rm -rf /etc/reboot_hack/reboot_hack
fi
cp sys/reboot_hack /etc/reboot_hack/reboot_hack

# Putting our modified powerbtn.sh in place of the original
if [ -f /etc/acpi/powerbtn.sh ]; then
	if [ ! -f /etc/acpi/powerbtn.sh.bak ]; then
		mv /etc/acpi/powerbtn.sh /etc/acpi/powerbtn.sh.bak
	fi
else rm -rf /etc/acpi/powerbtn.sh
fi
cp sys/powerbtn.sh /etc/acpi/powerbtn.sh

# Making all the symlinks
if [ -f /etc/init.d/reboot_hack ]; then
	rm -rf /etc/init.d/reboot_hack
fi
ln -s /bin/boot_check /etc/init.d/reboot_hack

if [ -f /etc/rc5.d/S99reboot_hack ]; then
	rm -rf /etc/rc5.d/S99reboot_hack
fi
ln -s /etc/init.d/reboot_hack /etc/rc5.d/S99reboot_hack

if [ -f /bin/boot_check ]; then
	rm -rf /bin/boot_check
fi
ln -s /etc/reboot_hack/boot_check /bin/boot_check

if [ -f /bin/log_shutdown_state ]; then
	rm -rf /bin/log_shutdown_state
fi
ln -s /etc/reboot_hack/log_shutdown_state /bin/log_shutdown_state
