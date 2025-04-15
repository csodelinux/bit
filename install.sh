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

# ========== Installer Logic ==========
show_menu() {
    local option="${BIT_OPTION:-}"

    if [[ -z "$option" && -t 0 ]]; then
        echo -e "${CYAN}Bit Installer Options${RESET}"
        echo "a) System install (make install or manual copy)"
        echo "r) Remove Bit from system (/usr/local/bin/bit)"
        read -p "Choose an option [a/r]: " option
    fi

    case "$option" in
        a)
            print_section "Performing System Installation"
            if [[ -f Makefile ]]; then
                sudo make install
            elif [[ -f bit ]]; then
                sudo install -m 755 bit /usr/local/bin/bit
            else
                error "'bit' binary not found. Aborting."
                exit 1
            fi
            success "Bit installed system-wide to /usr/local/bin/bit"
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
            error "Invalid or missing input. Set BIT_OPTION=a or r"
            exit 1
            ;;
    esac
    success "Exiting Bit installer."
}

# ========== Entrypoint ==========
show_menu
