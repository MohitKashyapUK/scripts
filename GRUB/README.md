# GRUB ISO Boot Configurations

नीचे कुछ ready-to-use GRUB menuentry दिए गए हैं जिन्हें आप अपनी `/etc/grub.d/40_custom` या किसी custom grub config file में डाल सकते हैं।  
बस variables (`isofile`, `partition`, `kernel_path`, `initrd_path`) अपने हिसाब से बदलें।  

---

## 🔹 Arch-based Distros (Arch, CachyOS, EndeavourOS, Garuda)

### Without `cow_spacesize`
```bash
menuentry "CachyOS ISO (no cow_spacesize)" {
    set isofile="/OS/cachyos-desktop-linux-250713.iso"
    set partition="(hd0,3)"
    set kernel_path="/arch/boot/x86_64/vmlinuz-linux-cachyos"
    set initrd_path="/arch/boot/x86_64/initramfs-linux-cachyos.img"

    loopback loop $partition$isofile
    linux (loop)$kernel_path img_dev=/dev/sda3 img_loop=$isofile earlymodules=loop
    initrd (loop)$initrd_path
}
````

### With `cow_spacesize` (example: 4G)

```bash
menuentry "CachyOS ISO (with cow_spacesize=4G)" {
    set isofile="/OS/cachyos-desktop-linux-250713.iso"
    set partition="(hd0,3)"
    set kernel_path="/arch/boot/x86_64/vmlinuz-linux-cachyos"
    set initrd_path="/arch/boot/x86_64/initramfs-linux-cachyos.img"

    loopback loop $partition$isofile
    linux (loop)$kernel_path img_dev=/dev/sda3 img_loop=$isofile earlymodules=loop cow_spacesize=4G
    initrd (loop)$initrd_path
}
```

---

## 🔹 Ubuntu/Debian-based Distros (Ubuntu, Linux Mint, etc.)

### Without `cow_spacesize`

```bash
menuentry "Ubuntu ISO (no cow_spacesize)" {
    set isofile="/OS/ubuntu-24.04-desktop-amd64.iso"
    set partition="(hd0,3)"
    set kernel_path="/casper/vmlinuz"
    set initrd_path="/casper/initrd"

    loopback loop $partition$isofile
    linux (loop)$kernel_path boot=casper iso-scan/filename=$isofile noeject noprompt splash --
    initrd (loop)$initrd_path
}
```

### With `cow_spacesize` (example: 4G)

```bash
menuentry "Ubuntu ISO (with cow_spacesize=4G)" {
    set isofile="/OS/ubuntu-24.04-desktop-amd64.iso"
    set partition="(hd0,3)"
    set kernel_path="/casper/vmlinuz"
    set initrd_path="/casper/initrd"

    loopback loop $partition$isofile
    linux (loop)$kernel_path boot=casper iso-scan/filename=$isofile noeject noprompt splash -- cow_spacesize=4G
    initrd (loop)$initrd_path
}
