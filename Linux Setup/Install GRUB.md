## Universal Linux GRUB Repair Guide (Chroot Method)

Agar aapka bootloader udd gaya hai, toh aap kisi bhi Linux Live USB se boot karke niche diye gaye steps follow kar sakte hain.

### 1. Drive aur Partitions Pehchaniye
Live environment mein terminal kholein aur check karein ki aapka root (`/`) aur EFI partition kaunsa hai:
```bash
lsblk -f
```
* **Root Partition:** Jahan aapka OS installed hai (manlo `/dev/sda2`).
* **EFI Partition:** Chota FAT32 partition (sirf UEFI systems ke liye, manlo `/dev/sda1`).

### 2. File System ko Mount Karein
Apne installed system ke partitions ko `/mnt` par mount karein. 

**Root Mount karein:**
```bash
sudo mount /dev/sdXn /mnt
```
*(Yahan `/dev/sdXn` ko apne asli root partition se badlein).*

**EFI Mount karein (Sirf UEFI ke liye):**
Agar aapka system UEFI mode mein hai, toh EFI partition ko `/mnt/boot/efi` par mount karein:
```bash
sudo mkdir -p /mnt/boot/efi
sudo mount /dev/sdXn /mnt/boot/efi
```

### 3. System Directories ko Bind karein
Chroot karne se pehle, Live system ke zaroori components ko installed system ke saath connect karna hota hai taaki internet aur hardware access mil sake:
```bash
for i in /dev /dev/pts /proc /sys /run; do sudo mount -B $i /mnt$i; done
```

### 4. Chroot Environment mein Enter karein
Ab aap apne installed system ke "andar" chale jayenge:
```bash
sudo chroot /mnt
```
*Ab jo bhi command aap run karenge, wo aapke HDD/SSD par asar karegi.*

### 5. GRUB Reinstall aur Update karein

**UEFI Systems ke liye:**
```bash
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
```

**BIOS/Legacy Systems ke liye:**
```bash
grub-install --target=i386-pc /dev/sdX 
# (Yahan 'sdX' poori drive hai, jaise 'sda', partition nahi)
```

**Config File Generate karein:**
Chahe Debian ho, Ubuntu ho ya Fedora, ye command zaroori hai:
```bash
grub-mkconfig -o /boot/grub/grub.cfg
```
*Note: Fedora mein kabhi-kabhi ye path `/boot/efi/EFI/fedora/grub.cfg` hota hai.*

### 6. Safely Exit aur Reboot
```bash
exit
sudo umount -R /mnt
sudo reboot
```

---

### Distro-Specific Tips:
* **Ubuntu/Debian:** Agar `grub-install` command nahi milti, toh chroot ke andar `apt update && apt install grub-pc` (BIOS) ya `grub-efi` (UEFI) karein.
* **Fedora:** Fedora `dnf` ka upyog karta hai. Agar config kaam na kare, toh `dnf reinstall grub2-efi shim` chroot ke andar try karein.
* **Dual Boot:** Agar Windows nahi dikh raha, toh `os-prober` install karke `grub-mkconfig` firse chalayein.
