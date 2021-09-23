#!/bin/bash
# SPDX-License-Identifier: GPL-2.0

set -eu

SIZE=2048

if [[ $# -ne 2 ]]; then
	echo "usage: $0 <image> <release>" >&2
	exit 2
fi
IMAGE=$1
RELEASE=$2

if [[ $EUID -ne 0 ]]; then
	echo 'error: please, run as root' >&2
	exit 1
fi

TMPDIR=$(mktemp -d)

FSDIR="${TMPDIR}/fs"
mkdir -p "${FSDIR}"

debootstrap --arch=amd64 "${RELEASE}" "${FSDIR}"

echo 'root:root' | chroot "${FSDIR}" chpasswd
echo 'linux-dev' > "${FSDIR}/etc/hostname"
cat << EOF > "${FSDIR}/etc/network/interfaces.d/default"
auto enp0s3
iface enp0s3 inet dhcp
EOF

MNTDIR="${TMPDIR}/mnt"
mkdir -p "${MNTDIR}"

dd if=/dev/zero of="${IMAGE}" bs=1M seek=$((SIZE-1)) count=1
mkfs.ext4 -F "${IMAGE}"
mount -o loop "${IMAGE}" "${MNTDIR}"
cp -a "${FSDIR}/." "${MNTDIR}/."
umount "${MNTDIR}"

rm -rf "${TMPDIR}"
