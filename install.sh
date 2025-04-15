#!/usr/bin/env bash

# ==================== Color Setup ====================
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
RESET='\033[0m'

# ==================== Helper Functions ====================
log()    { echo -e "${CYAN}[INFO]${RESET} $1"; }
success(){ echo -e "${GREEN}[OK]${RESET} $1"; }
error()  { echo -e "${RED}[ERROR]${RESET} $1"; exit 1; }

# ==================== Perform Install ====================
perform_install() {
    log "Starting Bit installation using 'make system-install'..."

    if [ -f "Makefile" ]; then
        make install
    else
        error "Makefile not found. Cannot continue installation."
    fi

    if command -v bit >/dev/null 2>&1; then
        success "Bit installed successfully and is available as a system command."
    else
        error "Bit installation failed or not available in PATH."
    fi
}

# ==================== Main ====================
perform_install
