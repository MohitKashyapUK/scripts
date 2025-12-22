# 🛠️ GRUB Boot Entry Recovery Guide (Arch Linux)

Yeh guide aapko kisi doosre Arch-based system (jaise CachyOS) ki boot entry recover karne ya reinstall karne mein madad karegi.

### Step 1: Install Arch Install Scripts
Sabse pehle check karein ki aapke paas `arch-chroot` tool hai ya nahi. Agar nahi hai, toh ise install karein:
```bash
sudo pacman -S arch-install-scripts
```

### Step 2: Identify and Mount Root Partition
Apne purane OS ki partition list check karein taaki sahi partition identify ho sake.
```bash
lsblk -f
```

Ab, ek temporary folder banayein aur usme apni **Root (/) partition** mount karein:
```bash
sudo mkdir -p /mnt/old-system
# Replace /dev/sdXY with your actual root partition (e.g., /dev/sda2)
sudo mount /dev/sdXY /mnt/old-system
```

### Step 3: Enter Chroot Environment
Apne purane system ke andar 'enter' karne ke liye niche di gayi command chalayein:
```bash
sudo arch-chroot /mnt/old-system
```

### Step 4: Mount EFI Partition
Chroot ke andar aane ke baad, aapko apni **EFI partition** mount karni hogi taaki GRUB files likhi ja sakein.
*Pehle check karein ki aapki EFI partition kaunsi hai (aksar 512MB ki hoti hai).*

```bash
mkdir -p /boot/efi
# Replace /dev/sdXn with your EFI partition (e.g., /dev/sda1)
mount /dev/sdXn /boot/efi
```

### Step 5: Reinstall GRUB and Update Config
Ab naya bootloader ID banayein aur configuration file update karein.

1. **GRUB Install karein:**
   ```bash
   grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=CachyOS-Old
   ```

2. **Config File generate karein:**
   ```bash
   grub-mkconfig -o /boot/grub/grub.cfg
   ```

### Step 6: Exit and Reboot
Kaam khatam hone ke baad chroot se bahar niklein aur system restart karein.
```bash
exit
sudo reboot
```

---
