# Buildroot config

## TODO:

- [x] Start xterm at boot
- [x] 8.5. Building out-of-tree (better files organization)
- [x] test generated image
- [ ] Run lmn-3 on start
- [ ] support many screens
- [ ] support many boards
- [ ] include some assets

## Usage:

cf. https://github.com/Enchan1207/rpi-buildroot/wiki/Usage

load buildroot container (this config file is pretty useless)

**On Host:**

```bash
# host
bin/buildroot.sh
```

> docker container has buildroot environments variables so it's not necessary to repeat it on each commands:
>
> ```
> BR2_EXTERNAL=/br_external
> FORCE_UNSAFE_CONFIGURE=1
> ```
>
> (except for "O" which is mandatory in the command line)

**In docker env:**

Then load the real config file

```bash
# docker
make O=/dist/rpi2-lmn-3 defconfig BR2_DEFCONFIG=/configs/rpi2_lmn-3_defconfig
```

Or create a new configuration:

```bash
# docker
make O=/dist/rpi-<name> raspberrypi2_defconfig
```

Configure

```bash
# docker
make O=/dist/rpi2-lmn-3 menuconfig
```

Save minimal configuration

```bash
# docker
make O=/dist/rpi2-lmn-3 savedefconfig BR2_DEFCONFIG=/configs/rpi2_hello_defconfig
```

_(Once the docker container is stop, fix the permissions on this file: `sudo chown -R $USER: config`)_

Build (takes a hour the first time, can be restarted if aborted)

```bash
# docker
make O=/dist/rpi2-lmn-3
```

Create a sysroot to build lmn-3-DAW

```bash
# TODO (not tested at all)
# docker

# produce dist/host files
make toolchain
# produce dist/images/…sdk-buildroot.tar.gz
make sdk
```

## Tests

Using qemu

### Pre-requisite

For raspi2b: Install qemu (armv7)

```bash
# host
sudo apt install qemu-system-arm
```

### Prepare

```bash
# host
sudo chown $USER: dist/images/*
qemu-img resize dist/images/sdcard.img 256M
```

### Start

cf. https://cboyer.github.io/linux/buildroot-raspberry/

```bash
# host

# full net + keyboard & mouse: doesn't work. cf. Troubleshoutings
qemu-system-arm \
 -machine raspi2b \
 -kernel dist/images/zImage \
 -dtb dist/images/bcm2709-rpi-2-b.dtb \
 -drive if=sd,driver=raw,file=dist/images/sdcard.img \
 -append "console=ttyAMA0 root=/dev/mmcblk0p2 rw rootwait rootfstype=ext4" \
 -device usb-net,netdev=net0 -netdev user,id=net0,hostfwd=tcp::5555-:80 \
 -device usb-mouse -device usb-kbd \
 -serial stdio

# minimal
qemu-system-arm \
 -machine raspi2b \
 -kernel dist/images/zImage \
 -dtb dist/images/bcm2709-rpi-2-b.dtb \
 -drive if=sd,driver=raw,file=dist/images/sdcard.img \
 -append "root=/dev/mmcblk0p2 rw rootwait rootfstype=ext4" \
 -serial stdio
```

## Steps

### deps for GUI:

cf. https://cboyer.github.io/linux/buildroot-raspberry-qt5/

```
System configuration
├─ System hostname (BR2_TARGET_GENERIC_HOSTNAME="buildrootqt5")
├─ Root password (BR2_TARGET_GENERIC_ROOT_PASSWD="root")
├─ remount root filesystem read-write during boot (BR2_TARGET_GENERIC_REMOUNT_ROOTFS_RW=n)
└─ Root filesystem overlay directories (BR2_ROOTFS_OVERLAY=output/rootfs_overlay)

Toolchain
└─ Enable WCHAR support (BR2_TOOLCHAIN_BUILDROOT_WCHAR=y)

Target packages
├─ Hardware handling
|  └─ rpi-userland (BR2_PACKAGE_RPI_USERLAND=y)
|
└─ Graphic libraries and applications (graphic/text)
   └─ Qt5 (BR2_PACKAGE_QT5=y)
      ├─ Custom configuration options (BR2_PACKAGE_QT5BASE_CUSTOM_CONF_OPTS
      |  [=-skip qtconnectivity -skip qtnetwork -skip qtgamepad -no-feature-vnc -no-feature-accessibility -nomake tests])
      ├─ eglfs support (BR2_PACKAGE_QT5BASE_EGLFS=y)
      └─ Default graphical platform (BR2_PACKAGE_QT5BASE_DEFAULT_QPA="eglfs")
```

https://stackoverflow.com/questions/71656946/how-to-build-a-linux-based-custom-os-with-gui-for-raspberry-pi-3b

- X Windows System Server --> modular xorg ( The X.Org project provides an open
  source implementation of the X Window)
- X.org X Window System, X11R7 --> X11R7 Applications --> xinit (gives startx
  command to begin GUI)
- X.org X Window System, X11R7 --> X11R7 Servers --> xorg-server (X server
  component)
- X.org X Window System, X11R7 --> X11R7 Drivers --> xf86-input-keyboard (very
  common interface :-)
- X.org X Window System, X11R7 --> X11R7 Drivers --> xf86-input-mouse X.org X
  Window System, X11R7 --> X11R7 Drivers --> xf86-video-cirrus (Cirrus VGA is
  emulated in QEMU)
- X.org X Window System, X11R7 --> X11R7 Drivers --> xf86-video-fbdev (or you
  can use framebuffer)
- X.org X Window System, X11R7 --> X11R7 Application --> you can add some useful
  applications
- X.org X Window System, X11R7 --> MatchBow Window Manager (The Matchbox window
  manager is responsible for managing X11 client window geometry and stacking
  order, as well as providing decorations and controls) or any other window
  manager of your choice. X.org X Window System, X11R7 --> rxtv (Terminal
  emulation program in X

### deps to install for juce:

(to check)

```
libasound2,
libfreetype6,
libgl1-mesa-glx | libgl1,
libx11-6,
libxext6,
libxinerama1
```

### Include external library

_(Within interactive buildroot.sh command)_

```bash
export BR2_EXTERNAL=/dist/pi2-config
make O=/dist menuconfig
```

```
External options  --->
   *** Custom configuration for Pi 2 (in /dist/pi2-config) ***

System configuration  --->
   Root filesystem overlay directories ($(BR2_EXTERNAL_PI4_CONFIG_PATH)/custom-rootfs)
```

## Troubleshoutings

### Messing up the `target` directory

The official way:

```bash
# docker
make clean
```

Alternatively (to save re-build time) see https://stackoverflow.com/a/49862790

```bash
# docker
rm -rf /dist/target
find /dist/ -name ".stamp_target_installed" -delete
rm -f /dist/build/host-gcc-final-*/.stamp_host_installed
```

### qemu: Kernel panic (qemu)

> SMP: failed to stop secondary CPUs
> [ 49.370383] ---[ end Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(179,2) ]---

### qemu: Sending NMI from CPU 1,2,3 to CPUs 0

> [ 25.102074] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
> [ 25.109962] rcu: 0-...!: (2 GPs behind) idle=bd30/0/0x0 softirq=79/79 fqs=0 (false positive?)
> [ 25.114226] rcu: 1-...!: (0 ticks this GP) idle=0288/0/0x0 softirq=339/339 fqs=0 (false positive?)
> [ 25.121789] rcu: (detected by 3, t=2102 jiffies, g=-1091, q=8 ncpus=4)
> [ 25.130896] Sending NMI from CPU 3 to CPUs 0

**Solution** remove the flags ` -device usb-mouse -device usb-kbd` from qemu command.

It seems that qemu is using [BCM2835 for serial ports and Cortex-A7 as CPU](https://www.qemu.org/docs/master/system/arm/raspi.html) but rpi2b is built with [BCM2836](https://www.raspberrypi.com/documentation/computers/processors.html#bcm2836) which supports Cortex-A7 CPU (where bc2835 doesn't)
