# Research on ACPI Functionality in Ubuntu 16.04 LTS

So far, I've found the way the process of an ACPI shutdown is initiated, and I've traced it a bit of the way down the rabbit-hole. Here's what I've found so far.

1. User presses "power button"
2. There is a config file which determines what file is executed when this event occurs:

        /etc/init/acpid.conf

	This file contains a line which reads:

		exec acpid -c /etc/acpi/events -s /var/run/acpid.socket

	When I looked at the directory of the first file, The first thing I noticed is there's a file called
	
		/etc/acpi/powerbtn.sh

	When I checked *that* file, I noticed it's a standard BASH script, which checks for various conditions when the power button is pressed and decides what to do based on those conditions. Here are some excerpts from the file:
	
		01 | #!/bin/sh
		02 | # /etc/acpi/powerbtn.sh
		03 | # Initiates a shutdown when the power putton has been pressed.
		04 |
		05 | [ -r /usr/share/acpi-support/power-funcs ] && . /usr/share/acpi-support/power-funcs
		~~~~
		08 | # If logind is running, it already handles power button presses;
		09 | # desktop environments put inhibitors to logind if they want to handle the key themselves.
		
My initial assessment is that if I simply place my script in between the conditionals in line 05, it should execute exactly the way I'm imagining it would. Line 05 is simply checking to see if the file

	/etc/acpi-support/power-funcs

exists and is readable and if it *is* then execute the file. So if ACPI functions are supported, then perform ACPI functions according to what should happen. In our case, ACPI button is purely binary.

	If (machine == on)
		poweroff
	If (machine == off)
		poweron

This will be my first attempt at this.
