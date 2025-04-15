#!/usr/bin/env bash

# ========== Color Setup ==========
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RESET='\033[0m'

# ========== Global Vars ==========
DISTRO=""
PACKAGE_MANAGER=""

# ========== Helper Functions ==========
log() {
    echo -e "${CYAN}[INFO]${RESET} $1"
}
warn() {
    echo -e "${YELLOW}[WARN]${RESET} $1"
}
error() {
    echo -e "${RED}[ERROR]${RESET} $1"
}
success() {
    echo -e "${GREEN}[OK]${RESET} $1"
}
print_section() {
    echo -e "\n${CYAN}==> $1${RESET}"
}
ask_yes_no() {
    read -p "$1 (y/n): " choice
    [[ "$choice" =~ ^[Yy]$ ]]
}

# ========== Core Logic ==========
option_shower() {
    ask_yes_no "Do you wish to continue?"
    if [[ $? -ne 0 ]]; then
        error "User chose to exit."
        exit 1
    fi
    clear
}

option_display() {
    clear
    echo -e "${CYAN}Bit Installer Options${RESET}"
    echo "a) System install (make install)"
    echo "b) Local build (make build)"
    echo "r) Remove bit from system (/usr/local/bin/bit)"
    read -p "Choose an option [a/b/r]: " option

    clear
    case "$option" in
        a)
            print_section "Performing System Installation"
            make install
            success "System-wide installation complete!"
            ;;
        b)
            print_section "Performing Local Build"
            make build
            success "Local build complete!"
            ;;
        r)
            print_section "Removing Bit"
            sudo rm -f /usr/local/bin/bit
            if [[ $? -eq 0 ]]; then
                success "Bit has been removed from the system."
            else
                error "Failed to remove Bit. Check if it exists or if you have permission."
            fi
            ;;
        *)
            error "Invalid input. Please choose 'a', 'b', or 'r'."
            sleep 1
            option_display  
            ;;
    esac
    echo
    success "Exiting Bit installer."
    exit 0
}

detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID

        if command -v apt >/dev/null 2>&1; then
            PACKAGE_MANAGER="apt"
        elif command -v dnf >/dev/null 2>&1; then
            PACKAGE_MANAGER="dnf"
        elif command -v pacman >/dev/null 2>&1; then
            PACKAGE_MANAGER="pacman"
        elif command -v zypper >/dev/null 2>&1; then
            PACKAGE_MANAGER="zypper"
        else
            warn "Could not detect package manager."
        fi

        log "Detected distribution: ${CYAN}$DISTRO${RESET} (Package manager: ${CYAN}$PACKAGE_MANAGER${RESET})"
    else
        warn "Could not detect Linux distribution. Some features may not work properly."
    fi
}

check_compiler() {
    if command -v gcc >/dev/null 2>&1; then
        success "GCC is already installed."
        return 0
    elif command -v clang >/dev/null 2>&1; then
        success "Clang is already installed."
        return 0
    else
        warn "No compiler detected (GCC or Clang)."
        return 1
    fi
}

install_compiler() {
    print_section "Checking for compilers..."
    if check_compiler; then
        sleep 1
        return 0
    fi

    ask_yes_no "No compiler found. Would you like to install GCC now?"
    if [[ $? -ne 0 ]]; then
        error "Compiler is required. Exiting."
        exit 1
    fi

    print_section "Installing GCC..."

    case "$PACKAGE_MANAGER" in
        apt)
            sudo apt update && sudo apt install -y gcc
            ;;
        dnf)
            sudo dnf install -y gcc
            ;;
        pacman)
            sudo pacman -Syu --noconfirm gcc
            ;;
        zypper)
            sudo zypper install -y gcc
            ;;
        *)
            warn "Unsupported package manager."
            ;;
    esac

    if command -v gcc >/dev/null 2>&1; then
        success "GCC installed successfully!"
    else
        error "GCC installation failed. Please install it manually."
        exit 1
    fi
    sleep 1
    clear
}

# ========== Entrypoint ==========
main() {
    clear
    print_section "Bit Installer"
    detect_distro
    option_shower
    install_compiler
    option_display
}

main
