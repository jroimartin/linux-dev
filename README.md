# Linux Kernel Development

Helpers for several kernel development tasks.

## scripts/create-image.sh

Creates a minimal Debian disk image.

## scripts/qemu.sh

Runs a VM using the specified kernel and disk image.

## scripts/prune-kernel.sh

Because I use `CONFIG_LOCALVERSION_AUTO`, not the same version again and again,
/boot and /lib/modules/ eventually fill up. This is a dumb script to purge that
stuff.

## docker/kerneldev-ubuntu

This Dockerfile allows to create build environments using a given Ubuntu
version. This is especially useful for building old kernels that require
specific gcc versions.
