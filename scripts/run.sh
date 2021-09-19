#!/bin/bash
# SPDX-License-Identifier: GPL-2.0

set -eu

BUILD_DIR=${BUILD_DIR:-"$PWD/build"}

qemu-system-x86_64 \
	-nographic \
	-nodefaults \
	-serial 'mon:stdio' \
	-kernel "${BUILD_DIR}/bzImage" \
	-initrd "${BUILD_DIR}/initramfs.cpio.gz" \
	-append 'console=ttyS0'
