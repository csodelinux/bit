#!/usr/bin/env bash

# ========== Color Setup ==========
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RESET='\033[0m'

# ========== Helper Functions ==========
log()      { echo -e "${CYAN}[INFO]${RESET} $1"; }
success()  { echo -e "${GREEN}[OK]${RESET} $1"; }
warn()     { echo -e "${YELLOW}[WARN]${RESET} $1"; }
error()    { echo -e "${RED}[ERROR]${RESET} $1"; }

# ========== Paths ==========
INSTALL_DIR="/opt/bit"
BIN_PATH="/usr/local/bin/bit"

log "Starting Bit uninstallation..."

# Remove install directory
if [ -d "$INSTALL_DIR" ]; then
    sudo rm -rf "$INSTALL_DIR"
    success "Removed Bit installation directory: $INSTALL_DIR"
else
    warn "Bit install directory not found: $INSTALL_DIR"
fi

# Remove binary
if [ -f "$BIN_PATH" ]; then
    sudo rm -f "$BIN_PATH"
    success "Removed Bit binary: $BIN_PATH"
else
    warn "Bit binary not found at $BIN_PATH"
fi

success "Bit has been fully uninstalled."
