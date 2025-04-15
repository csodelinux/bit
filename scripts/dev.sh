#!/usr/bin/env bash

# Colors
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
RESET='\033[0m'

REPO_URL="https://github.com/csodelinux/bit.git"
CLONE_DIR="bit-dev-temp"

log()    { echo -e "${CYAN}[INFO]${RESET} $1"; }
warn()   { echo -e "${YELLOW}[WARN]${RESET} $1"; }
error()  { echo -e "${RED}[ERROR]${RESET} $1"; }
success(){ echo -e "${GREEN}[OK]${RESET} $1"; }

ask_yes_no() {
    read -p "$1 (y/n): " response
    [[ "$response" =~ ^[Yy]$ ]]
}

# Clone the dev branch
log "Cloning the 'dev' branch from Bit..."
git clone --depth 1 --single-branch --branch dev "$REPO_URL" "$CLONE_DIR"

if [ $? -ne 0 ]; then
    error "Failed to clone repository."
    exit 1
fi
success "Cloned successfully into ./${CLONE_DIR}"

# Run the installer from the dev branch
log "Running installer from dev branch..."
cd "$CLONE_DIR"
bash install.sh

cd ../..

# Ask to delete the folder
sudo rm -rf "$CLONE_DIR"
success "Removed the directory."

success "Dev installation complete."
