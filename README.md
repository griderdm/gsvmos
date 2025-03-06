# gsvmos
A sample operating system designed to run on the GSVM CPU1.

## Assumptions
This OS assumes that your virtual machine is set up using the stock GSVM hardware and the CPU is a CPU1.
The GSVMOS may run on the CPU2 without modification, but as the CPU2 is still in the exploratory phase, this cannot be said with certainty.

## Arrangement
The software is broken into two core pieces, the BIOS, which lives on DISK0, and the OS, which lives on one of the other disks.
It is recommended that you set it to DISK1, though if you set it to anything else, you should change the settings in the BIOS during POST.
Also supplied is a blank, unbootable VMFS1-formatted disk that you may make copies of to set to any of the other disks.

### BIOS
The BIOS contains code for the Power-On Self-Test and basic I/O. Once the I/O system is initialized, the POST code executes, and the boot
sector of the appropriate disk is loaded and control is handed over to the boot sector. In the case that the boot sector is to an
unbootable disk, a warning will appear on the screen.
