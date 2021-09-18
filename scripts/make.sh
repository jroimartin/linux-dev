#!/bin/bash
# SPDX-License-Identifier: GPL-2.0

set -eu

if [[ $# -ne 2 ]]; then
	echo "usage: $0 <path_to_kernel_src> <path_to_busybox_install>" >&2
	exit 1
fi
KDIR=$1
BUSYBOX_INSTALL=$2

BUILD_DIR=${BUILD_DIR:-$PWD/build}

if [[ -e $BUILD_DIR ]]; then
	echo "warning: build dir '${BUILD_DIR}' already exists" >&2
fi

mkdir -p "${BUILD_DIR}/initramfs/"{bin,sbin,lib,usr,etc,proc,sys}

# Build kernel.

pushd "${KDIR}"
make -j 16
make modules_install INSTALL_MOD_PATH="${BUILD_DIR}/initramfs/"
cp arch/x86_64/boot/bzImage "${BUILD_DIR}"
popd

# Build initramfs.

cat <<EOF > "${BUILD_DIR}/initramfs/init"
#!/bin/sh
# SPDX-License-Identifier: GPL-2.0

mount -t proc none /proc
mount -t sysfs none /sys

exec /bin/sh
EOF

chmod +x "${BUILD_DIR}/initramfs/init"
cp -a "${BUSYBOX_INSTALL}/"* "${BUILD_DIR}/initramfs/"

pushd "${BUILD_DIR}/initramfs/"
find . -print0 | cpio --null -o -H newc | gzip > ../initramfs.cpio.gz
popd
