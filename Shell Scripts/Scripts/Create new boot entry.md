**Note: This process is for Arch Linux**

1. Download `arch-chroot`
    ```shell
    sudo pacman -S arch-install-scripts
    ```
2. Mount the OS's partition
     ```shell
     sudo mkdir -p /mnt/old-cachy
     ```
     - *Replace your OS's partition name with /dev/sdXY.* Get a list of partitions `lsblk -f`
     ```shell
     sudo mount /dev/sdXY /mnt/old-cachy
     ```
3. Change the root directory to the target OS partition
     ```shell
     sudo arch-chroot /mnt/old-cachy
     ```
5. Now, you are in the chroot. Run these commands in the chroot to create a new boot entry.
     - *Mount EFI partition*
         ```shell
         mkdir -p /boot/efi
         mount /dev/sda1 /boot/efi
         ```
     - *Change the entry name in --bootloader-id*
     ```shell
     grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=CachyOS-Old
     ```
     ```shell
     grub-mkconfig -o /boot/grub/grub.cfg
     ```
