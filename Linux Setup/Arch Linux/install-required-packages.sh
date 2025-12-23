#!/bin/bash

# --- Step 0: Base Directory ko HOME par set karna ---
# Sabse pehle Home folder mein jaayenge taaki permission ka issue na ho
cd "$HOME" || { echo "Error: Home directory mein nahi ja saka."; exit 1; }
echo "Working directory set to: $HOME"

# 1. Apna URL yahan dalein
LIST_URL="https://example.com/my-packages.txt"

# --- Step 1: System Update ---
echo "System update kar raha hoon..."
sudo pacman -Syu --noconfirm

# --- Step 2: Check & Install 'yay' ---
if ! command -v yay &> /dev/null; then
    echo "'yay' installed nahi hai. Installation shuru kar raha hoon..."

    # 2a. Git aur Base-devel tools install karna
    sudo pacman -S --needed --noconfirm git base-devel

    # 2b. Yay ko clone karna (Ab ye pakka Home folder mein hoga)
    git clone https://aur.archlinux.org/yay.git
    cd yay

    # 2c. Build aur Install karna
    makepkg -si --noconfirm

    # 2d. Safayi karna aur wapas Home mein aana
    cd "$HOME"
    rm -rf yay

    echo "'yay' safalta purvak install ho gaya!"
else
    echo "'yay' pehle se installed hai."
fi

# --- Step 3: Fetch Package List ---
if [ -z "$LIST_URL" ]; then
    echo "Error: URL set nahi hai."
    exit 1
fi

echo "URL se package list download kar raha hoon..."
PACKAGES=$(curl -fsSL "$LIST_URL" | sed 's/#.*//' | xargs)

if [ -z "$PACKAGES" ]; then
    echo "Error: List khali hai ya download fail ho gayi."
    exit 1
fi

echo "Ye packages install honge: $PACKAGES"

# --- Step 4: Install Applications ---
echo "Applications install kar raha hoon..."
yay -S --needed --noconfirm $PACKAGES

echo "Sab set hai! Script complete."
