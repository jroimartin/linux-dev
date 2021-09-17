# Linux Kernel Development

## scripts/{make.sh,run.sh}

### Usage

Build the Linux kernel and the initramfs file:

```
./scripts/make.sh
```

Run the kernel in qemu:

```
./scripts/run.sh
```

### Prerequisites

#### Linux kernel

Create a config file.

#### Busybox

Get the source code:

```
git clone https://git.busybox.net/busybox
```

Checkout the last stable version:

```
git checkout 1_33_1
```

Configure the build:

```
make defconfig
make menuconfig
```

Enable static build:

```
-> Settings
  --- Build Options
  [*] Build static binary (no shared libs)
```

Build busybox:

```
make -j 16
make install
```
