#!/usr/bin/env bash

# Colors
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
RESET='\033[0m'

REPO_URL="https://github.com/csodelinux/bit.git"
INSTALL_DIR="/opt/bit"

log()    { echo -e "${CYAN}[INFO]${RESET} $1"; }
warn()   { echo -e "${YELLOW}[WARN]${RESET} $1"; }
error()  { echo -e "${RED}[ERROR]${RESET} $1"; }
success(){ echo -e "${GREEN}[OK]${RESET} $1"; }

# Clone the dev branch to /opt/bit
log "Cloning the 'dev' branch from Bit into ${INSTALL_DIR}..."
sudo git clone --depth 1 --single-branch --branch dev "$REPO_URL" "$INSTALL_DIR"

if [ $? -ne 0 ]; then
    error "Failed to clone repository."
    exit 1
fi
success "Cloned successfully into $INSTALL_DIR"

# Run the installer
log "Running installer from dev branch..."
cd "$INSTALL_DIR"
sudo bash install.sh

# Remove the cloned directory
log "Cleaning up..."
sudo rm -rf "$INSTALL_DIR"
success "Removed the repository."

success "Bit (dev version) has been installed successfully."
