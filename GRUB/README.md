---

### Menu Entry to Boot an ISO from GRUB

This guide will help you create a custom menu entry in your GRUB bootloader to boot directly from an ISO file located on your hard drive. It provides complete code examples for both Arch Linux and Ubuntu/Debian-based distributions.

#### 1. Configurable Variables

Before using the code, you **must** update the four variables in the `=== CONFIGURABLE VARIABLES ===` section to match your system's setup.

*   `set isofile="/OS/cachyos-desktop-linux-250713.iso"`: Replace this with the correct path to your ISO file on your hard drive.
*   `set partition="(hd0,3)"`: Replace this with the partition where your ISO file is stored. GRUB names partitions differently (e.g., the third partition on the first disk, `/dev/sda3`, is typically `(hd0,3)`).
*   `set kernel_path="/arch/boot/x86_64/vmlinuz-linux-cachyos"`: Set the correct path to the kernel *inside* the ISO file.
*   `set initrd_path="/arch/boot/x86_64/initramfs-linux-cachyos.img"`: Set the correct path to the initrd image *inside* the ISO file.

---

### 2. Full Code for Arch Linux

For Arch-based distributions, you must update the `img_dev=/dev/sdXY` parameter in the `linux` line to point to the partition where the ISO file is located (e.g., `/dev/sda3`).

```bash
menuentry "OS name (Arch-based)" {
    # === CONFIGURABLE VARIABLES ===
    set isofile="/OS/cachyos-desktop-linux-250713.iso"
    set partition="(hd0,3)"
    set kernel_path="/arch/boot/x86_64/vmlinuz-linux-cachyos"
    set initrd_path="/arch/boot/x86_64/initramfs-linux-cachyos.img"
 
    # === BOOT SETUP ===
    loopback loop $partition$isofile
    linux (loop)$kernel_path img_dev=/dev/sdXY img_loop=$isofile earlymodules=loop
    initrd (loop)$initrd_path
}
```

#### Optional: Increasing Temporary Space for Arch

When you run a live OS, changes are stored in RAM in a temporary filesystem ("copy-on-write" or "cow space"). If you need more space for tasks like installing large applications, you can expand this temporary storage.

To do this, add the `cow_spacesize` option to the end of the `linux` line. Here is how you would modify the Arch Linux code block to allocate a 4GB temporary space:

```bash
menuentry "OS name (Arch-based with 4G Space)" {
    # === CONFIGURABLE VARIABLES ===
    set isofile="/OS/cachyos-desktop-linux-250713.iso"
    set partition="(hd0,3)"
    set kernel_path="/arch/boot/x86_64/vmlinuz-linux-cachyos"
    set initrd_path="/arch/boot/x86_64/initramfs-linux-cachyos.img"
 
    # === BOOT SETUP ===
    loopback loop $partition$isofile
    linux (loop)$kernel_path img_dev=/dev/sdXY img_loop=$isofile earlymodules=loop cow_spacesize=4G
    initrd (loop)$initrd_path
}
```

---

### 3. Full Code for Ubuntu/Debian

If you are booting an Ubuntu or Debian-based distribution, use the following code block. This version replaces the `linux ...` line with the one that uses the `casper` boot script, which is standard for these systems.

```bash
menuentry "OS name (Ubuntu/Debian-based)" {
    # === CONFIGURABLE VARIABLES ===
    set isofile="/OS/cachyos-desktop-linux-250713.iso"
    set partition="(hd0,3)"
    set kernel_path="/arch/boot/x86_64/vmlinuz-linux-cachyos"
    set initrd_path="/arch/boot/x86_64/initramfs-linux-cachyos.img"
 
    # === BOOT SETUP ===
    loopback loop $partition$isofile
    linux (loop)$kernel_path boot=casper iso-scan/filename=$isofile noeject noprompt splash --
    initrd (loop)$initrd_path
}
```
---
