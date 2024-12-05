#!/bin/bash

# ----------------------------
# Colors and Icons Definitions
# ----------------------------
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No color

CHECKMARK="✅"
ERROR="❌"
PROGRESS="⏳"
INSTALL="📦"
SUCCESS="🎉"
WARNING="⚠️"
NODE="🖥️"
INFO="ℹ️"

# Icons for the header
ICON_TELEGRAM="🚀"
ICON_INSTALL="🛠️"
ICON_DELETE="🗑️"
ICON_UPDATE="🔄"
ICON_LOGS="📄"
ICON_CONFIG="⚙️"
ICON_EXIT="🚪"

# ----------------------------
# ASCII Art Header
# ----------------------------
display_ascii() {
    clear
    echo -e "    ${RED}    ____  __ __    _   ______  ____  ___________${NC}"
    echo -e "    ${GREEN}   / __ \\/ //_/   / | / / __ \\/ __ \\/ ____/ ___/${NC}"
    echo -e "    ${BLUE}  / / / / ,<     /  |/ / / / / / / / __/  \\__ \\ ${NC}"
    echo -e "    ${YELLOW} / /_/ / /| |   / /|  / /_/ / /_/ / /___ ___/ / ${NC}"
    echo -e "    ${MAGENTA}/_____/_/ |_|  /_/ |_/\____/_____/_____//____/  ${NC}"
    echo -e "    ${MAGENTA}${ICON_TELEGRAM} Follow us on Telegram: https://t.me/dknodes${NC}"
    echo -e "    ${MAGENTA}📢 Follow us on Twitter: https://x.com/dknodes${NC}"
}

# ----------------------------
# Menu Borders
# ----------------------------
draw_top_border() {
    echo -e "${BLUE}╔══════════════════════════════════════════════════════╗${NC}"
}

draw_middle_border() {
    echo -e "${BLUE}╠══════════════════════════════════════════════════════╣${NC}"
}

draw_bottom_border() {
    echo -e "${BLUE}╚══════════════════════════════════════════════════════╝${NC}"
}

# ----------------------------
# Main Menu Function
# ----------------------------
main_menu() {
    while true; do
        display_ascii
        draw_top_border
        echo -e "  ${SUCCESS}  ${GREEN}Welcome to the Lens Node Installation Wizard!${NC}"
        draw_middle_border
        echo -e "${CYAN}  1) Clone and Start the Lens Node ${ICON_INSTALL}${NC}"
        echo -e "${CYAN}  2) Stop the Node ${ICON_DELETE}${NC}"
        echo -e "${CYAN}  3) View Logs ${ICON_LOGS}${NC}"
        echo -e "${CYAN}  4) Exit ${ICON_EXIT}${NC}"
        draw_bottom_border
        read -p "Choose an option: " action

        case $action in
            1)
                clone_lens_node
                start_lens_node
                read -p "Press Enter to return to the main menu..." ;;
            2)
                stop_lens_node
                read -p "Press Enter to return to the main menu..." ;;
            3)
                view_lens_node_logs
                read -p "Press Enter to return to the main menu..." ;;
            4)
                echo "Exiting the program..."
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid choice. Please try again.${NC}"
                read -p "Press Enter to return to the main menu..." ;;
        esac
    done
}

# Function to clone the Lens Node repository
clone_lens_node() {
    echo "Cloning the Lens Node repository..."
    git clone https://github.com/lens-network/lens-node && cd lens-node
    echo "Lens Node repository cloned."
}

# Function to start the Lens Node
start_lens_node() {
    echo "Starting the Lens Node..."
    docker-compose --file testnet-external-node.yml up -d
    if [ $? -eq 0 ]; then
        echo "Lens Node successfully started."
    else
        echo "Error while starting the Lens Node."
    fi
}

# Function to stop the Lens Node
stop_lens_node() {
    echo "Stopping the Lens Node..."
    docker-compose down
    if [ $? -eq 0 ]; then
        echo "Lens Node successfully stopped."
    else
        echo "Error while stopping the Lens Node."
    fi
}

# Function to view Lens Node logs
view_lens_node_logs() {
    echo "Viewing the last 50 logs of the Lens Node..."
    docker logs -f --tail=100 lens-node-external-node-1
    echo "Logs displayed."
}

# Function to check the health of the Lens Node
check_lens_node_health() {
    echo "Checking the health of the Lens Node..."
    curl http://localhost:3081/health
}

# Execute Main Menu
main_menu