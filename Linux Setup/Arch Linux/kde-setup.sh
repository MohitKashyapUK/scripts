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
   log_info "Upyog: sudo ./kde-setup.sh"
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

# Detect Script Directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

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

# --- Section 3: Package Installation ---
install_packages() {
    log_task "Packages installation setup..."

    SCRIPT_NAME="install-packages.sh"
    SCRIPT_FULL_PATH="$SCRIPT_DIR/$SCRIPT_NAME"
    
    # 1. Update System (Running as Root)
    log_info "Updating system and ensuring base-devel/git/curl (Root)..."
    pacman -Syu --noconfirm --needed git base-devel curl

    # Fallback URL
    REMOTE_URL="https://raw.githubusercontent.com/MohitKashyapUK/scripts/refs/heads/main/Linux%20Setup/Arch%20Linux/install-packages.sh"

    # 2. Check and Download if missing
    if [ ! -f "$SCRIPT_FULL_PATH" ]; then
        log_warning "Local script '$SCRIPT_NAME' not found. Trying to download..."
        if curl -s -o "$SCRIPT_FULL_PATH" "$REMOTE_URL"; then
            log_success "Script downloaded successfully."
        else
            log_error "Failed to download script from $REMOTE_URL"
            return 1
        fi
    fi

    # 3. Run User Script
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
        log_error "Local script '$SCRIPT_NAME' still not found."
        return 1
    fi
    log_success "Package installation completed."
}

# --- Execution ---
setup_firewall || log_error "Firewall setup fail ho gaya, par aage badh rahe hain..."
echo ""
install_packages || log_error "Package installation fail ho gaya."

echo -e "\n${GREEN}=========================================${NC}"
echo -e "${GREEN}         Setup Process Finished!         ${NC}"
echo -e "${GREEN}=========================================${NC}"
