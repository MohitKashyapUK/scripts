# Arch Linux Setup

Is folder mein Arch Linux ke liye essential packages aur complete system setup script hai.

## 📦 Files

- **`setup.sh`**: Complete setup script (firewall, KDE configuration, packages)
- **`install-required-packages.sh`**: Packages installation script
- **`pkglist.txt`**: Essential packages list
- **`KDE_CONFIGURATION.md`**: KDE Plasma settings documentation

## 🚀 Quick Setup (Recommended)

Complete system setup ke liye (firewall + KDE configuration + packages):

```bash
# Download and run setup script
curl -fsSL https://raw.githubusercontent.com/MohitKashyapUK/scripts/main/Linux%20Setup/Arch%20Linux/setup.sh -o setup.sh
chmod +x setup.sh
sudo ./setup.sh
```

## 📋 What Does setup.sh Do?

1. **Root Permission Check**: Script ko sudo ke saath run karna zaroori hai
2. **Firewall Configuration**: KDE Connect ports (1714-1764) ko open karta hai
   - Supports: UFW, firewalld, iptables
   - Agar koi firewall nahi hai, to UFW install karta hai
3. **KDE Plasma Configuration** (agar KDE installed hai):
   - ⚡ Animation speed optimized
   - 🔒 Screen locking disabled
   - 🔋 Power management configured
   - 💾 Empty session on login
4. **Package Installation**: Essential packages install karta hai

## 🎨 KDE Plasma Settings

Script automatically ye 4 settings configure karti hai:

- **Animation Speed**: One step before instant (faster than default)
- **Screen Lock**: Never lock automatically
- **Power Management**: Do nothing when inactive, dim after 10 min, never turn off screen
- **Session**: Start with empty session

Detailed documentation: [KDE_CONFIGURATION.md](./KDE_CONFIGURATION.md)

## 📦 Packages Only Installation

Agar sirf packages install karne hain (without firewall/KDE config):

```bash
curl -fsSL https://raw.githubusercontent.com/MohitKashyapUK/scripts/main/Linux%20Setup/Arch%20Linux/install-required-packages.sh | bash
```

## 🛠️ Manual Usage

### Setup Script
```bash
chmod +x setup.sh
sudo ./setup.sh
```

### Package Installation Script
```bash
chmod +x install-required-packages.sh
./install-required-packages.sh
```

## 📝 Notes

- `setup.sh` ko **root permissions** ke saath run karna zaroori hai
- KDE settings automatically detect aur configure hoti hain
- **KDE Plasma 5 aur 6 dono supported hain** (script automatically detect karti hai)
- Agar KDE Plasma nahi hai, to KDE configuration skip ho jati hai
- Kuch settings ko fully apply karne ke liye logout/login karein

## 🔧 Customization

Agar aap KDE settings manually change karna chahte hain, to [KDE_CONFIGURATION.md](./KDE_CONFIGURATION.md) dekhen.
