# Buildroot config

## TODO:

- [ ] Start xterm at boot
- [ ] Drop ethernet support (qemu)
- [ ] Standalone buildroot docker container

## Usage:

cf. https://github.com/Enchan1207/rpi-buildroot/wiki/Usage

load buildroot container (this config file is pretty useless)
```bash
buildroot.sh hello.config
```

Then load the real config file

```bash
make O=/dist BR2_EXTERNAL=/dist/pi2-config defconfig BR2_DEFCONFIG=/dist/config/rpi2_hello_defconfig
```

Configure

```bash
make O=/dist menuconfig
```

Save minimal configuration

```bash
make O=/dist savedefconfig BR2_DEFCONFIG=/dist/config/rpi2_hello_defconfig
```

Build

```bash
make O=/dist
```

## Debug

Prerequisite: qemu

```bash
# Check image size
qemu-img info dist/images/sdcard.img

# fix image size
qemu-img resize -f raw dist/images/sdcard.img 256M

# Run rpi emulator
qemu-system-arm -M raspi2b -m 1024 \
-kernel dist/images/zImage \
-dtb dist/images/bcm2709-rpi-2-b.dtb \
-drive if=sd,driver=raw,file=dist/images/sdcard.img \
-append "console=ttyAMA0 root=/dev/mmcblk0p2 rw rootwait rootfstype=ext4" \
-device usb-net,netdev=net0 -netdev user,id=net0,hostfwd=tcp::5555-:80 \
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


-  X Windows System Server --> modular xorg ( The X.Org project provides an open source implementation of the X Window)
-  X.org X Window System, X11R7 --> X11R7 Applications --> xinit (gives startx command to begin GUI)
-  X.org X Window System, X11R7 --> X11R7 Servers --> xorg-server (X server component)
-  X.org X Window System, X11R7 --> X11R7 Drivers --> xf86-input-keyboard (very common interface :-)
-  X.org X Window System, X11R7 --> X11R7 Drivers --> xf86-input-mouse X.org X Window System, X11R7 --> X11R7 Drivers --> xf86-video-cirrus (Cirrus VGA is emulated in QEMU)
-  X.org X Window System, X11R7 --> X11R7 Drivers --> xf86-video-fbdev (or you can use framebuffer)
-  X.org X Window System, X11R7 --> X11R7 Application --> you can add some useful applications
-  X.org X Window System, X11R7 --> MatchBow Window Manager (The Matchbox window manager is responsible for managing X11 client window geometry and stacking order, as well as providing decorations and controls) or any other window manager of your choice.
X.org X Window System, X11R7 --> rxtv (Terminal emulation program in X

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
