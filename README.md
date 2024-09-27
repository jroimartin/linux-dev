# Linux Kernel Development

Helpers for several kernel development tasks.

## qemu-linux-dev

This `qemu-linux-dev` script makes easier to test kernels in qemu.
It expects a kernel and a file system image as inputs.

### Usage

```
qemu-linux-dev <rootfs> <bzImage>
```

### Rootfs image

Initialize the `buildroot` submodule.

```
git submodule init
git submodule update
```

Configure buildroot to use `linux-dev_defconfig`.

```
make -C buildroot linux-dev_defconfig BR2_EXTERNAL=../br2-external
```

Create the rootfs image.

```
make -C buildroot -j8 BR2_EXTERNAL=../br2-external
```

### SSH access

Qemu forwards `localhost:10022` to the VM SSH server.

```
ssh -p 10022 root@localhost
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

It assumes that the kernel source tree has been cloned into
`~/src/linux/`.

### Kernel modules

Install the modules of the kernel being tested into the
[/overlay-extra] directory.

```
make modules_install INSTALL_MOD_PATH=~/src/linux-dev/br2-external/user/overlay/
```

The previous command assumes that this repository has been cloned into
`~/src/linux-dev/`.

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
[buildroot configuration]: /config-buildroot.x86_64
[/overlay-extra]: /overlay-extra
[emacs configuration]: https://github.com/jroimartin/dotfiles/blob/76260967707f0a7cad2c2d69c86cc1dc9d6b1502/.emacs.d/init.el#L267
