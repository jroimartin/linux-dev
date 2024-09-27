# Linux Kernel Development

Helpers for several kernel development tasks.

## qemu-linux-dev

This `qemu-linux-dev` script makes easier to test kernels in qemu.
It expects a kernel and a rootfs image as inputs.

The rootfs image can be built with [buildroot].
This repository provides a default buildroot configuration as well as
an overlay that configures sshd to allow root access with empty
password.
The [/br2-external/user/overlay/] directory can be used to include
additional files in the generated rootfs image.

**Note:** The instructions in this document assume the following
locations:

- `~/src/linux-dev`: This repository.
- `~/src/buildroot`: Buildroot source tree.
- `~/src/linux`: Linux kernel source tree.

### Usage

```
qemu-linux-dev <rootfs> <bzImage>
```

### Rootfs image

Clone the buildroot repository:

```
git clone https://gitlab.com/buildroot.org/buildroot.git ~/src/buildroot
```

Configure buildroot to use `linux-dev_defconfig`.

```
make -C ~/src/buildroot linux-dev_defconfig BR2_EXTERNAL=~/src/linux-dev/br2-external
```

Create the rootfs image.

```
make -C ~/src/buildroot -j8 BR2_EXTERNAL=~/src/linux-dev/br2-external
```

### SSH access

Qemu forwards `localhost:10022` to the VM SSH server.

```
ssh -p 10022 root@localhost
```

The following ssh configuration is useful to avoid fingerprint errors
after a rootfs update.
Add it to `~/.ssh/config`.

```
Host localhost
	StrictHostKeyChecking no
	GlobalKnownHostsFile /dev/null
	UserKnownHostsFile /dev/null
```

### KGDB

A GDB server listens at `localhost:1234`.
So a typical gdb session would look like this:

```
gdb vmlinux
target remote :1234
```

If `CONFIG_GDB_SCRIPTS` is enabled, you might need to add the
following to `~/.config/gdb/gdbinit`:

```
add-auto-load-safe-path ~/src/linux/
```

### Kernel modules

Install the modules of the kernel being tested into the
[/br2-external/user/overlay/] directory.

```
make modules_install INSTALL_MOD_PATH=~/src/linux-dev/br2-external/user/overlay/
```

## LSP

Install `clangd` and [configure][emacs configuration] your editor to
use it.
Then, generate a `compile_commands.json` file at the root of the
kernel source tree.

```
./scripts/clang-tools/gen_compile_commands.py
```

## build-kernel

This Dockerfile creates build environments using a given Ubuntu
version.
This is specially useful for building old kernels that require
specific gcc versions.

### Build

```
docker build \
  [--build-arg UBUNTU_VERSION=<version>] \
  [--build-arg USER_ID=<host_uid>] \
  [--build-arg GROUP_ID=<host_gid>] \
  [--build-arg USERNAME=<username>] \
  -t build-kernel:<version> .
```

### Run

```
docker run \
  -ti --rm \
  -v <kernel_path>:<kernel_path> \
  build-kernel:<version>
```


[buildroot]: https://buildroot.org/
[/br2-external/user/overlay/]: /br2-external/user/overlay/
[emacs configuration]: https://github.com/jroimartin/dotfiles/blob/76260967707f0a7cad2c2d69c86cc1dc9d6b1502/.emacs.d/init.el#L267
