#!/bin/bash

# --- Configuration: Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Error Handling
handle_error() {
    log_error "Error at line $1. Installation stopped."
    exit 1
}
trap 'handle_error $LINENO' ERR

# Start
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
LOCAL_PKG_LIST="$SCRIPT_DIR/pkglist.txt"
LIST_URL="https://raw.githubusercontent.com/MohitKashyapUK/scripts/main/Linux%20Setup/Arch%20Linux/pkglist.txt"

# --- REMOVED SYSTEM UPDATE SECTION FROM HERE ---
# The parent script (setup.sh) acts as root and updates the system.

# 2. Install Yay
if ! command -v yay &> /dev/null; then
    log_info "Installing yay..."
    # We assume base-devel and git are installed by parent script or pre-installed
    cd "$HOME" || exit 1
    rm -rf yay
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
else
    log_info "yay is already installed."
fi

# 3. Install Packages
if [ -f "$LOCAL_PKG_LIST" ]; then
    log_info "Using local package list: $LOCAL_PKG_LIST"
    PACKAGES=$(sed 's/#.*//' "$LOCAL_PKG_LIST" | xargs)
else
    log_info "Downloading package list from GitHub..."
    PACKAGES=$(curl -fsSL "$LIST_URL" | sed 's/#.*//' | xargs)
fi

if [ -z "$PACKAGES" ]; then
    log_error "Package list is empty."
    exit 1
fi

log_info "Installing packages: $PACKAGES"
# yay will ask for password if needed. 
yay -S --needed --noconfirm $PACKAGES

echo -e "${GREEN}Package installation complete!${NC}"
