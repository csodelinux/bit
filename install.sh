#!/usr/bin/env bash

# ========== Color Setup ==========
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RESET='\033[0m'

# ========== Helper Functions ==========
log()       { echo -e "${CYAN}[INFO]${RESET} $1"; }
warn()      { echo -e "${YELLOW}[WARN]${RESET} $1"; }
error()     { echo -e "${RED}[ERROR]${RESET} $1"; }
success()   { echo -e "${GREEN}[OK]${RESET} $1"; }
print_section() { echo -e "\n${CYAN}==> $1${RESET}"; }

# ========== Installer Options ==========
show_menu() {
    echo -e "${CYAN}Bit Installer Options${RESET}"
    echo "a) System install (make install or manual copy)"
    echo "r) Remove Bit from system (/usr/local/bin/bit)"
    read -p "Choose an option [a/r]: " option

    case "$option" in
        a)
            print_section "Performing System Installation"
            if [[ -f Makefile ]]; then
                sudo make install
            else
                sudo install -m 755 bit /usr/local/bin/bit
            fi
            if [[ $? -eq 0 ]]; then
                success "Bit installed system-wide to /usr/local/bin/bit"
            else
                error "Installation failed."
                exit 1
            fi
            ;;
        r)
            print_section "Removing Bit"
            sudo rm -f /usr/local/bin/bit
            if [[ $? -eq 0 ]]; then
                success "Bit has been removed from the system."
            else
                error "Failed to remove Bit. Does it exist?"
            fi
            ;;
        *)
            error "Invalid input. Please choose 'a' or 'r'."
            sleep 1
            show_menu
            ;;
    esac
    echo
    success "Exiting Bit installer."
}

# ========== Entrypoint ==========
show_menu
