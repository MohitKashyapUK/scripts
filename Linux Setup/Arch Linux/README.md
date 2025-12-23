# Arch Linux Setup

Is folder mein Arch Linux ke liye essential packages aur unhe install karne ki script hai.

## Packages list
`pkglist.txt` mein wo saare packages hain jo is script ke zariye install honge.

## Quick Installation
Niche diye gaye command ko copy karein aur terminal mein paste karein. Ye automatic saare packages download aur install kar dega (ye script 'yay' AUR helper ka use karti hai, agar 'yay' nahi hai toh ye use bhi install kar degi).

```bash
curl -fsSL https://raw.githubusercontent.com/MohitKashyapUK/scripts/main/Linux%20Setup/Arch%20Linux/install-required-packages.sh | bash
```

## Manual Usage
Agar aap script ko download karke run karna chahte hain:

1. Script ko executable banayein:
   ```bash
   chmod +x install-required-packages.sh
   ```
2. Script run karein:
   ```bash
   ./install-required-packages.sh
   ```
