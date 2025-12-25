# KDE Plasma Configuration Guide

यह document `setup.sh` script द्वारा automatically configure की जाने वाली KDE Plasma settings को explain करता है।

## 🎨 Configured Settings

Script केवल ये **4 essential settings** configure करती है:

**Note**: Script automatically KDE Plasma 5 (`kwriteconfig5`) aur KDE Plasma 6 (`kwriteconfig6`) dono ko support karti hai.

### 1. **Animation Speed**
- **Setting**: One step before instant (1)
- **Default**: 5 (Normal)
- **File**: `~/.config/kdeglobals`

```bash
kwriteconfig5 --file kdeglobals --group KDE --key AnimationDurationFactor 1
```

**Note**: 0 = Instant, 1 = Very Fast, 5 = Default

### 2. **Screen Locking**
- **Auto-lock**: Disabled (Never)
- **Lock on Resume**: Enabled (Lock after waking from sleep)
- **Timeout**: 0 (Never)
- **File**: `~/.config/kscreenlockerrc`

```bash
kwriteconfig5 --file kscreenlockerrc --group Daemon --key Autolock false
kwriteconfig5 --file kscreenlockerrc --group Daemon --key LockOnResume true
kwriteconfig5 --file kscreenlockerrc --group Daemon --key Timeout 0
```

### 3. **Power Management**
Complete power management settings as per user preferences:

**File**: `~/.config/powermanagementprofilesrc`

#### Suspend Session
```bash
# When inactive - Do nothing
kwriteconfig6 --file powermanagementprofilesrc --group AC --group SuspendSession --key suspendType 0
```

#### Display and Brightness
```bash
# Dim automatically after 10 minutes
kwriteconfig6 --file powermanagementprofilesrc --group AC --group DimDisplay --key idleTime 600000

# Turn off screen - Never
kwriteconfig6 --file powermanagementprofilesrc --group AC --group DPMSControl --key idleTime 0
```

**Note**: "Other Settings" section (power button behavior, etc.) ko script touch nahi karti.

### 4. **Desktop Session**
- **Session Restore**: Start with empty session
- **File**: `~/.config/ksmserverrc`

```bash
kwriteconfig5 --file ksmserverrc --group General --key loginMode emptySession
```

**Note**: Previous applications won't restore on login.

## 🔧 Manual Configuration

Agar aap manually koi setting change karna chahte hain:

### Single Setting Change
```bash
kwriteconfig5 --file <config-file> --group <group-name> --key <key-name> <value>
```

### Example: Theme ko Breeze Light mein change karna
```bash
kwriteconfig5 --file kdeglobals --group General --key ColorScheme "BreezeLight"
kwriteconfig5 --file kdeglobals --group KDE --key LookAndFeelPackage "org.kde.breeze.desktop"
```

### Example: Single-click enable karna
```bash
kwriteconfig5 --file kdeglobals --group KDE --key SingleClick true
```

### Example: Screen lock ko 5 minutes ke baad enable karna
```bash
kwriteconfig5 --file kscreenlockerrc --group Daemon --key Autolock true
kwriteconfig5 --file kscreenlockerrc --group Daemon --key Timeout 300
```

## 📁 Configuration Files Location

Sabhi KDE configuration files `~/.config/` directory mein store hoti hain:

- **Theme & Appearance**: `~/.config/kdeglobals`
- **Window Manager**: `~/.config/kwinrc`
- **Screen Locker**: `~/.config/kscreenlockerrc`
- **Power Management**: `~/.config/powermanagementprofilesrc`
- **Session Management**: `~/.config/ksmserverrc`
- **Plasma Desktop**: `~/.config/plasma-org.kde.plasma.desktop-appletsrc`

## 🔄 Apply Changes

Settings apply karne ke liye:

### Method 1: Plasma Shell Restart (Recommended)
```bash
kquitapp5 plasmashell && kstart5 plasmashell
```

### Method 2: KWin Reconfigure
```bash
qdbus org.kde.KWin /KWin reconfigure
```

### Method 3: Logout/Login (Most Reliable)
```bash
# Simply logout and login again
```

## 🛠️ Troubleshooting

### Settings apply nahi ho rahi hain?
1. Plasma shell restart karein:
   ```bash
   kquitapp5 plasmashell && kstart5 plasmashell
   ```

2. Agar phir bhi nahi ho rahi, to logout/login karein

### Config file corrupt ho gayi?
```bash
# Backup lein
cp ~/.config/kdeglobals ~/.config/kdeglobals.backup

# Default settings restore karein
rm ~/.config/kdeglobals
# Logout/login karein
```

### Specific setting check karna?
```bash
kreadconfig5 --file kdeglobals --group General --key ColorScheme
```

## 📝 Notes

- Script automatically detect करती है ki KDE Plasma installed hai ya nahi
- Agar KDE nahi mila, to configuration skip ho jati hai
- Script `sudo` ke saath run hoti hai, lekin settings actual user ke liye apply hoti hain
- Kuch settings ko fully apply karne ke liye logout/login zaruri hai

## 🔗 References

- [KDE Configuration Files Documentation](https://userbase.kde.org/KDE_System_Administration/Configuration_Files)
- [kwriteconfig5 Manual](https://docs.kde.org/stable5/en/kdelibs/kdelibs/kwriteconfig5.html)
- [KDE Plasma Customization](https://userbase.kde.org/Plasma)
