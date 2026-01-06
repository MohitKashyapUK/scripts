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

# Detect Actual User
ACTUAL_USER="${SUDO_USER:-$USER}"

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

setup_kde || log_error "KDE setup fail ho gaya, par aage badh rahe hain..."