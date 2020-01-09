# ubuntu_reboot_hack

This is a highly specific network hack/workaround for a very specific ubuntu machine. It probably won't help you, but it's FOSS if you want to use/modify it. That said, here's a quick breakdown of what this is doing, and why:

## The Problem This is Meant to Solve

The problem this is "solving" (and by that, I mean "a **really** hacky work-around") is that I have a machine running Ubuntu 16.04 server which has some **really** unconventional (read: weird and not great) networking settings that for the time-being must remain as-is until something better can be figured out. As a result, the network config doesn't work when the machine is powered on from a previously powered off state. However, if the machine performs a soft reboot *after* being powered on and completing the boot process (i.e. getting to a login prompt, and *then* rebooting the machine), then all the weird network config stuff works. This machine is frequently powered on and off as we develop software on this platform. This machine is never intended to have a monitor, keyboard, or mouse plugged into it unless it is undergoing maintenence or hardware troubleshooting. Obviously, this "network-needing-a-soft-reboot-after-every-power-down" situation is untenable. So for the time-being, I'm making this hackjob work-around to get us by until I can come up with a more permanent solution to the networking problem.

## High-Level Description of the Hack

Breakdown of the script by conditions:
### ACPI Shutdown, i.e. someone presses the power button to initiate a quick, but graceful shutdown of the machine

1. A script named

        shutdown_script

	will hijack the ACPI-shutdown command and will insert (and execute) a command at the beginning of the queue of commands involved in the ACPI shutdown process. This command will edit a file (and if the file doesn't exist, it will create the file) called
	    
		last_shutdown.stat
	
	and write to that file
	    
		ACPI-SHUTDOWN
	
	to indicate the machine was completely powered off.
	
2. The next time the machine is powered on, a second script called

       boot_check
	
	will be run upon boot. It is yet to be determined *how* this will be accomplished. It could be done by placing it on the last line of the file
	
		~/.bashrc
	
	or it could be a cron job. Don't know yet. Cross that bridge when we get to it.

3. The script

        boot_check

	will execute look for the file
	
	    last_shutdown.stat
	
	and read its contents.

    ##### 3a. If it contains the following:

        ACPI-SHUTDOWN
	
    then it will overwrite the existing file with:
	
	    SOFT-REBOOT
	
	Once it confirms the file is written, it will reboot the machine.
	
	##### 3b. If *no* file is present:
	
	It will assume an emergency shutdown occurred (e.g. the machine's batteries died, or something malfunctioned, and the machine experienced an irregular shutdown and lost power), and will create the file and write to it:
	
	    SOFT-REBOOT
	
	then the system will reboot.

	##### 3c. If it contains the following:
	
	    SOFT-REBOOT
	
	It will assume the machine has already performed a soft reboot, and will do nothing, allowing the machine to follow normal boot procedure, and the user may resume using the machine as normal.

## How This Will Accomplish These Tasks

1. Still not sure how I will hijack the ACPI Shutdown procedure, but I'm looking into it.
2. Still not sure how I will execute the script upon boot. I think it would be good to have it execute in

        cron

    because users will not be able to SSH into the machine until the corresponding network interfaces come up, and they won't come up if it doesn't reboot, so this seems like the lowest-risk way to perform this task. If it's all done by root, then there's no need to much around with asking for credentials, and as long as it isn't executable by regular users, this should be safe from malicious misuse.
3. As for everything else, it's just reading and writing to files. Should be pretty straightforward.