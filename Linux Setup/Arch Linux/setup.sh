#!/bin/bash

# --- Configuration: Colors & Styles ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# --- Helper Functions ---
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_task() { echo -e "${CYAN}[TASK]${NC} $1"; }
log_success() { echo -e "${GREEN}[OK]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# --- Start Script ---
echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}         Arch Linux Setup Script         ${NC}"
echo -e "${BLUE}=========================================${NC}\n"

# 1. Check Root
if [[ $EUID -ne 0 ]]; then
   log_error "Is script ko root permissions ke saath run karein."
   log_info "Upyog: sudo ./setup.sh"
   exit 1
fi

# Detect Actual User
ACTUAL_USER="${SUDO_USER:-$USER}"
ACTUAL_HOME=$(eval echo ~$ACTUAL_USER)

if [ "$ACTUAL_USER" == "root" ]; then
    log_warning "Script root user ke taur par run ho rahi hai."
else
    log_info "Actual User Detected: $ACTUAL_USER"
fi

# --- Section 1: Firewall ---
setup_firewall() {
    log_task "Firewall configure kar raha hoon..."
    
    FIREWALL_DETECTED="none"
    if systemctl is-active --quiet firewalld; then FIREWALL_DETECTED="firewalld";
    elif systemctl is-active --quiet ufw; then FIREWALL_DETECTED="ufw";
    elif command -v iptables &> /dev/null && systemctl is-active --quiet iptables; then FIREWALL_DETECTED="iptables"; fi

    case $FIREWALL_DETECTED in
        firewalld)
            firewall-cmd --permanent --add-port=1714-1764/udp >/dev/null
            firewall-cmd --permanent --add-port=1714-1764/tcp >/dev/null
            firewall-cmd --reload >/dev/null
            log_success "Firewalld configured for KDE Connect."
;;
        ufw)
            ufw allow 1714:1764/udp >/dev/null
            ufw allow 1714:1764/tcp >/dev/null
            ufw reload >/dev/null
            log_success "UFW configured for KDE Connect."
;;
        iptables)
            iptables -A INPUT -p udp --dport 1714:1764 -j ACCEPT
            iptables -A INPUT -p tcp --dport 1714:1764 -j ACCEPT
            [ -x "$(command -v iptables-save)" ] && iptables-save > /etc/iptables/iptables.rules
            log_success "Iptables configured for KDE Connect."
;;
        none)
            log_warning "No firewall active. Installing UFW..."
            if ! command -v ufw &>/dev/null; then pacman -S --noconfirm ufw >/dev/null; fi
            ufw allow 1714:1764/udp >/dev/null
            ufw allow 1714:1764/tcp >/dev/null
            systemctl enable --now ufw >/dev/null
            ufw --force enable >/dev/null
            ufw reload >/dev/null
            log_success "UFW installed and configured."
;;
    esac
}

# --- Section 2: KDE Plasma Settings ---
setup_kde() {
    log_task "KDE Plasma settings check kar raha hoon..."

    if [ "$XDG_CURRENT_DESKTOP" = "KDE" ] || [ "$DESKTOP_SESSION" = "plasma" ] || command -v kwriteconfig6 &>/dev/null || command -v kwriteconfig5 &>/dev/null; then
        if [ "$ACTUAL_USER" != "root" ]; then
            log_info "Applying settings for user: $ACTUAL_USER"

            # Execute KDE Configuration directly as Actual User
            if runuser -l "$ACTUAL_USER" -s /bin/bash <<'EOF'
                set -e
                # Detect Command
                if command -v kwriteconfig6 &>/dev/null; then KC=kwriteconfig6;
                elif command -v kwriteconfig5 &>/dev/null; then KC=kwriteconfig5;
                else echo -e "\033[0;31m[ERROR]\033[0m KDE tools not found inside user session"; exit 1; fi

                echo -e "\033[0;34m[INFO]\033[0m Using config tool: $KC"

                # 1. Animation Speed
                $KC --file kdeglobals --group KDE --key AnimationDurationFactor 0.07

                # 2. Screen Locking
                $KC --file kscreenlockerrc --group Daemon --key Autolock false
                $KC --file kscreenlockerrc --group Daemon --key LockOnResume false
                $KC --file kscreenlockerrc --group Daemon --key Timeout 0

                # 3. Power Management (Plasma 6 Fixed)
                $KC --file powerdevilrc --group AC --group SuspendAndShutdown --key AutoSuspendAction 0
                $KC --file powerdevilrc --group AC --group Display --key TurnOffDisplayWhenIdle false

                # 4. Session
                $KC --file ksmserverrc --group General --key loginMode emptySession
EOF
            then
                log_success "KDE Settings Applied."
            else
                log_error "KDE settings apply karne mein error aaya."
                return 1
            fi

            # Restart Plasma
            log_info "Restarting Plasma..."
            runuser -l "$ACTUAL_USER" -s /bin/bash <<'EOF'
                if command -v kquitapp6 &>/dev/null; then
                    kquitapp6 plasmashell 2>/dev/null || true
                    sleep 2
                    systemctl --user restart plasma-plasmashell 2>/dev/null || plasmashell 2>/dev/null &
                elif command -v kquitapp5 &>/dev/null; then
                    kquitapp5 plasmashell 2>/dev/null || true
                    sleep 2
                    kstart5 plasmashell 2>/dev/null &
                fi
EOF
            log_success "Plasma restart signal sent."
        else
            log_warning "Root user detected, skipping KDE config."
        fi
    else
        log_warning "KDE Plasma not detected."
    fi
}

# --- Section 3: Package Installation ---
install_packages() {
    log_task "Packages installation setup..."

    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
    SCRIPT_NAME="install-required-packages.sh"
    SCRIPT_FULL_PATH="$SCRIPT_DIR/$SCRIPT_NAME"
    
    # 1. Update System (Running as Root)
    log_info "Updating system and ensuring base-devel/git (Root)..."
    pacman -Syu --noconfirm --needed git base-devel

    # 2. Run User Script
    if [ -f "$SCRIPT_FULL_PATH" ]; then
        log_info "Local package script found."

        # Permission fix
        chown "$ACTUAL_USER:$ACTUAL_USER" "$SCRIPT_FULL_PATH"
        chmod +x "$SCRIPT_FULL_PATH"

        # Execute Local Script using sudo -u to preserve terminal for yay prompts
        log_info "Running local script as $ACTUAL_USER..."
        
        # Using sudo -u allows better interactive handling than su -c
        if ! sudo -u "$ACTUAL_USER" bash "$SCRIPT_FULL_PATH"; then
            log_error "Local script execution failed."
            return 1
        fi
    else
        log_error "Local script '$SCRIPT_NAME' not found in $SCRIPT_DIR"
        log_info "Please create the install-required-packages.sh file locally first."
        return 1
    fi
    log_success "Package installation completed."
}

# --- Execution ---
setup_firewall || log_error "Firewall setup fail ho gaya, par aage badh rahe hain..."
echo ""
setup_kde || log_error "KDE setup fail ho gaya, par aage badh rahe hain..."
echo ""
install_packages || log_error "Package installation fail ho gaya."

echo -e "\n${GREEN}=========================================${NC}"
echo -e "${GREEN}         Setup Process Finished!         ${NC}"
echo -e "${GREEN}=========================================${NC}"
