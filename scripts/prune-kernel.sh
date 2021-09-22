#!/bin/bash
# SPDX-License-Identifier: GPL-2.0

# This script is based on
# https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/scripts/prune-kernel
# and has been adapted to work with Debian.

# Because I use CONFIG_LOCALVERSION_AUTO, not the same version again and again,
# /boot and /lib/modules/ eventually fill up. This is a dumb script to purge
# that stuff.

for f in "$@"
do
        if dpkg -S "/lib/modules/$f" >/dev/null; then
                echo "keeping $f (installed from apt)"
        elif [ $(uname -r) = "$f" ]; then
                echo "keeping $f (running kernel) "
        else
                echo "removing $f"
                rm -f "/boot/initramfs-$f.img" "/boot/System.map-$f"
                rm -f "/boot/vmlinuz-$f"   "/boot/config-$f"
                rm -rf "/lib/modules/$f"
		update-grub
        fi
done
