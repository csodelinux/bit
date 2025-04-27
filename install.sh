#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Bit Installer v1.0${NC}"

# Parse command line arguments
SYSTEM_WIDE=0
for arg in "$@"; do
  case $arg in
    --system|--system-wide)
      SYSTEM_WIDE=1
      shift
      ;;
  esac
done

# Check if system-wide installation requires sudo
if [ "$SYSTEM_WIDE" -eq 1 ] && [ "$EUID" -ne 0 ]; then
  echo -e "${RED}System-wide installation requires sudo privileges.${NC}"
  echo -e "Please run: ${YELLOW}sudo bash -c \"\$(curl -sSL https://your-install-url.com)\" -- --system${NC}"
  exit 1
fi

# Create temp directory
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# Check for dependencies
echo "Checking dependencies..."
command -v git >/dev/null 2>&1 || { echo -e "${RED}Error: git is required but not installed.${NC}"; exit 1; }
command -v cmake >/dev/null 2>&1 || { echo -e "${RED}Error: cmake is required but not installed.${NC}"; exit 1; }
command -v make >/dev/null 2>&1 || { echo -e "${RED}Error: make is required but not installed.${NC}"; exit 1; }

# Clone the repository
echo "Downloading source code..."
git clone https://github.com/yourusername/bit.git
cd bit

# Create build directory
mkdir -p build
cd build

# Build and install
if [ "$SYSTEM_WIDE" -eq 1 ]; then
  echo -e "${YELLOW}Configuring for system-wide installation...${NC}"
  cmake .. -DSYSTEM_WIDE_INSTALL=ON
  
  echo "Building..."
  make -j$(nproc)
  
  echo -e "${YELLOW}Installing system-wide...${NC}"
  make install
  
  echo -e "${GREEN}System-wide installation complete!${NC}"
  echo -e "The 'bit' executable is now available in your PATH."
else
  echo "Configuring for local installation..."
  # Set installation prefix to ~/.local for regular users
  cmake .. -DCMAKE_INSTALL_PREFIX=$HOME/.local
  
  echo "Building..."
  make -j$(nproc)
  
  echo "Installing locally..."
  make install
  
  # Add to PATH if needed
  if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo -e "${YELLOW}Adding $HOME/.local/bin to your PATH...${NC}"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> $HOME/.bashrc
    echo -e "Please run: ${YELLOW}source $HOME/.bashrc${NC} or start a new terminal."
  fi
  
  echo -e "${GREEN}Local installation complete!${NC}"
  echo -e "The 'bit' executable is installed in ${YELLOW}$HOME/.local/bin${NC}"
fi

# Clean up
cd ../..
rm -rf "$TEMP_DIR"

echo -e "${GREEN}Installation completed successfully.${NC}"
