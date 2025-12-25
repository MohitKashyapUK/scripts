#!/bin/bash

# Colors for better visibility
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}----- Arch Linux Setup Script -----${NC}\n"

# 1. Check for root permissions
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}Error: Is script ko root permissions ke saath run karein.${NC}"
   echo "Upyog: sudo ./setup.sh"
   exit 1
fi

# 2. Configure firewall (KDE Connect ports) and make it permanent
echo -e "${BLUE}Firewall configure ho raha hai...${NC}"

# Detect which firewall is active
FIREWALL_DETECTED="none"

if systemctl is-active --quiet firewalld; then
    FIREWALL_DETECTED="firewalld"
elif systemctl is-active --quiet ufw; then
    FIREWALL_DETECTED="ufw"
elif command -v iptables &> /dev/null && systemctl is-active --quiet iptables; then
    FIREWALL_DETECTED="iptables"
fi

# Configure KDE Connect ports based on detected firewall
case $FIREWALL_DETECTED in
    firewalld)
        echo -e "${GREEN}firewalld detected. Isme KDE Connect ports configure kar rahe hain...${NC}"
        firewall-cmd --permanent --add-port=1714-1764/udp
        firewall-cmd --permanent --add-port=1714-1764/tcp
        firewall-cmd --reload
        echo -e "${GREEN}[OK] KDE Connect ports firewalld mein open hain.${NC}"
        ;;
    
    ufw)
        echo -e "${GREEN}UFW detected. Isme KDE Connect ports configure kar rahe hain...${NC}"
        ufw allow 1714:1764/udp
        ufw allow 1714:1764/tcp
        ufw reload
        echo -e "${GREEN}[OK] KDE Connect ports UFW mein open hain.${NC}"
        ;;
    
    iptables)
        echo -e "${GREEN}iptables detected. Isme KDE Connect ports configure kar rahe hain...${NC}"
        iptables -A INPUT -p udp --dport 1714:1764 -j ACCEPT
        iptables -A INPUT -p tcp --dport 1714:1764 -j ACCEPT
        # Save rules permanently
        if command -v iptables-save &> /dev/null; then
            iptables-save > /etc/iptables/iptables.rules
        fi
        echo -e "${GREEN}[OK] KDE Connect ports iptables mein open hain.${NC}"
        ;;
    
    none)
        echo -e "${BLUE}Koi firewall active nahi hai. UFW install aur configure kar rahe hain...${NC}"
        # Install UFW if not present
        if ! command -v ufw &> /dev/null; then
            pacman -S --noconfirm ufw
        fi
        # Configure UFW
        ufw allow 1714:1764/udp
        ufw allow 1714:1764/tcp
        systemctl enable --now ufw
        ufw --force enable
        ufw reload
        echo -e "${GREEN}[OK] UFW install hua aur KDE Connect ports open hain.${NC}"
        ;;
esac

# 3. Configure KDE Plasma settings (if detected)
echo -e "${BLUE}\nKDE Plasma settings check kar rahe hain...${NC}"

# Function to configure KDE settings for a specific user
configure_kde_for_user() {
    local username=$1
    local user_home=$2
    
    echo -e "${BLUE}User '$username' ke liye KDE settings configure ho rahi hain...${NC}"
    
    # Run commands as the specific user
    sudo -u "$username" bash << 'EOF'
    # Detect which KDE version is available
    KWRITE_CMD=""
    if command -v kwriteconfig6 &> /dev/null; then
        KWRITE_CMD="kwriteconfig6"
        echo "KDE Plasma 6 detected. Settings configure ho rahi hain..."
    elif command -v kwriteconfig5 &> /dev/null; then
        KWRITE_CMD="kwriteconfig5"
        echo "KDE Plasma 5 detected. Settings configure ho rahi hain..."
    else
        echo "KDE Plasma tools nahi mile. Skipping KDE configuration..."
        exit 0
    fi
    
    # 1. Animation Speed - One step before instant (1 instead of 0)
    $KWRITE_CMD --file kdeglobals --group KDE --key AnimationDurationFactor 1
    
    # 2. Screen Locking - Never lock automatically
    $KWRITE_CMD --file kscreenlockerrc --group Daemon --key Autolock false
    $KWRITE_CMD --file kscreenlockerrc --group Daemon --key LockOnResume true
    $KWRITE_CMD --file kscreenlockerrc --group Daemon --key Timeout 0
    
    # 3. Power Management Settings
    # Suspend Session - When inactive: Do nothing
    $KWRITE_CMD --file powermanagementprofilesrc --group AC --group SuspendSession --key suspendType 0
    
    # Display and Brightness - Dim automatically: 10 minutes
    $KWRITE_CMD --file powermanagementprofilesrc --group AC --group DimDisplay --key idleTime 600000
    
    # Display and Brightness - Turn off screen: Never
    $KWRITE_CMD --file powermanagementprofilesrc --group AC --group DPMSControl --key idleTime 0
    
    # 4. Desktop Session - Start with empty session
    $KWRITE_CMD --file ksmserverrc --group General --key loginMode emptySession
    
    echo "KDE Plasma settings successfully configure ho gayi hain!"
EOF
}

# Detect KDE Plasma and configure settings
if [ "$XDG_CURRENT_DESKTOP" = "KDE" ] || [ "$DESKTOP_SESSION" = "plasma" ] || command -v kwriteconfig6 &> /dev/null || command -v kwriteconfig5 &> /dev/null; then
    echo -e "${GREEN}KDE Plasma detected!${NC}"
    
    # Get the actual user (not root) who invoked sudo
    ACTUAL_USER="${SUDO_USER:-$USER}"
    ACTUAL_HOME=$(eval echo ~$ACTUAL_USER)
    
    if [ "$ACTUAL_USER" != "root" ]; then
        configure_kde_for_user "$ACTUAL_USER" "$ACTUAL_HOME"
        
        # Restart Plasma to apply changes (optional, user can logout/login instead)
        echo -e "${BLUE}Settings apply karne ke liye Plasma restart kar rahe hain...${NC}"
        
        # Check which KDE version is available
        if command -v kquitapp6 &> /dev/null; then
            echo -e "${BLUE}KDE Plasma 6 restart ho raha hai...${NC}"
            sudo -u "$ACTUAL_USER" bash << 'EOF'
            if command -v kquitapp6 &> /dev/null; then
                kquitapp6 plasmashell 2>/dev/null
                sleep 2
                systemctl --user restart plasma-plasmashell 2>/dev/null || plasmashell 2>/dev/null &
                
                # Reconfigure KWin
                if command -v qdbus6 &> /dev/null; then
                    qdbus6 org.kde.KWin /KWin reconfigure 2>/dev/null
                else
                    echo "Warning: qdbus6 command nahi mila. KWin reconfigure skip ho raha hai."
                fi
            else
                echo "Error: kquitapp6 command nahi mila. Plasma restart fail ho gaya."
            fi
EOF
        elif command -v kquitapp5 &> /dev/null && command -v kstart5 &> /dev/null; then
            echo -e "${BLUE}KDE Plasma 5 restart ho raha hai...${NC}"
            sudo -u "$ACTUAL_USER" bash << 'EOF'
            if command -v kquitapp5 &> /dev/null && command -v kstart5 &> /dev/null; then
                kquitapp5 plasmashell 2>/dev/null
                sleep 2
                kstart5 plasmashell 2>/dev/null &
                
                # Reconfigure KWin
                if command -v qdbus &> /dev/null; then
                    qdbus org.kde.KWin /KWin reconfigure 2>/dev/null
                else
                    echo "Warning: qdbus command nahi mila. KWin reconfigure skip ho raha hai."
                fi
            else
                echo "Error: kquitapp5/kstart5 commands nahi mile. Plasma restart fail ho gaya."
            fi
EOF
        else
            echo -e "${BLUE}KDE Plasma restart commands nahi mile. Settings apply karne ke liye logout/login karein.${NC}"
        fi

        echo -e "${GREEN}[OK] KDE Plasma settings configure ho gayi hain.${NC}"
        echo -e "${BLUE}Note: Kuch settings ko fully apply karne ke liye logout/login karein.${NC}"
    else
        echo -e "${BLUE}Normal user nahi mila. KDE configuration skip kar rahe hain.${NC}"
    fi
else
    echo -e "${BLUE}KDE Plasma nahi mila. KDE configuration skip kar rahe hain.${NC}"
fi

# 4. Install packages
echo -e "${BLUE}\nPackages install ho rahe hain...${NC}"

# Local script ko priority dena agar wo available hai
# if [ -f "./install-required-packages.sh" ]; then
#     bash ./install-required-packages.sh
# else
#     curl -fsSL https://github.com/MohitKashyapUK/scripts/raw/refs/heads/main/Linux%20Setup/Arch%20Linux/install-required-packages.sh | bash
# fi

echo -e "${GREEN}Setup successfully complete ho gaya!${NC}"
