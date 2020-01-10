#!/bin/bash

# Description: This will read a file at
# 	/root/ubuntu_reboot_hack/last_shutdown.stat
# which will describe the nature of the last reboot in one of the following messages:
#
# ACPI-SHUTDOWN
# SOFT-REBOOT
#
# This script will have 3 different behaviors based on what it finds:
#
# ACPI-SHUTDOWN
#	Overwrite /root/ubuntu_reboot_hack/last_shutdown.stat with the following:
#		SOFT-REBOOT
#	Reboot the machine as soon as boot process completes.
#
# SOFT-REBOOT
#	Nothing. Continue the boot process normally, and exit.
#
# [FILE NOT FOUND]
#	Overwrite /root/ubuntu_reboot_hack/last_shutdown.stat with the following:
#		SOFT-REBOOT
#	Reboot the machine as soon as boot process completes.

shutdown_stat=""
if [ -f /root/ubuntu_reboot_hack/last_shutdown.stat ]; then
	shutdown_stat=$(cat /root/ubuntu_reboot_hack/last_shutdown.stat)
	if [[ "$shutdown_stat" == "ACPI-SHUTDOWN" ]]; then
		if cat "SOFT-REBOOT" > /root/ubuntu_reboot_hack/last_shutdown.stat; then
			reboot
		else exit 1
		fi
	elif [[ "$shutdown_stat" == "SOFT-REBOOT" ]]; then
		exit 0
	fi
else
	if cat "SOFT-REBOOT" > /root/ubuntu_reboot_hack/last_shutdown.stat; then
		reboot
	else exit 1
	fi
fi
exit 0