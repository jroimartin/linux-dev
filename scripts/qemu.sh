#!/bin/bash
# SPDX-License-Identifier: GPL-2.0

set -eu

CPUS=2

if [[ $# -ne 2 ]]; then
	echo "usage: $0 <image> <kernel>" >&2
	exit 2
fi
IMAGE=$1
KERNEL=$2

QEMUFLAGS=${QEMUFLAGS:-}

qemu-system-x86_64 \
	-enable-kvm \
	-nographic \
	-smp "cpus=${CPUS}" \
	-kernel "${KERNEL}" \
	-append 'root=/dev/sda rw console=ttyS0' \
	-drive "file=${IMAGE},media=disk,format=raw" \
	${QEMUFLAGS}
