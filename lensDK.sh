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
        echo -e "${CYAN}  4) Check Node Health ${ICON_CONFIG}${NC}"
        echo -e "${CYAN}  5) Update Node${ICON_CONFIG}${NC}"
        echo -e "${CYAN}  6) Exit ${ICON_EXIT}${NC}"
        draw_bottom_border
        read -p "Choose an option: " action

        case $action in
            1)
                install_docker
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
                check_lens_node_health
                read -p "Press Enter to return to the main menu..." ;;
            5)
                lens_update
                read -p "Press Enter to return to the main menu..." ;;
            6)
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


lens_update() {
    cd lens-node
    git pull
    echo "Starting the Lens Node..."
    docker-compose --file testnet-external-node.yml restart
    if [ $? -eq 0 ]; then
        echo "Lens Node successfully update and restarted."
    else
        echo "Error while restarting the Lens Node."
    fi
}

# Function to stop the Lens Node
stop_lens_node() {
    echo "Stopping the Lens Node..."
    if [ -d "lens-node" ]; then
        cd lens-node
        docker-compose --file testnet-external-node.yml down
    else
        echo "Directory lens-node not found, cannot stop the node."
    fi
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

# Function to check the health of the Lens Node with colorful JSON output
check_lens_node_health() {
    echo "Checking the health of the Lens Node..."
    response=$(curl -s http://localhost:3081/health)

    # Check if the response was successful
    if [ $? -eq 0 ]; then
        echo "$response" | jq .  # This will pretty-print the JSON with colors
        echo "Lens Node is healthy."
    else
        echo "Lens Node is not responding or unhealthy."
    fi
}

# Function to install Docker and Docker Compose
install_docker() {
    sudo apt-get install jq
    echo "Checking for Docker..."
    if ! command -v docker &> /dev/null; then
        echo "Docker not found. Installing Docker..."
        sudo apt-get update
        sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        sudo usermod -aG docker $USER
        echo "Docker installed."
    else
        echo "Docker is already installed."
    fi

    echo "Checking for Docker Compose..."
    if ! command -v docker-compose &> /dev/null; then
        echo "Docker Compose not found. Installing Docker Compose..."
        sudo curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r .tag_name)/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
        echo "Docker Compose installed."
    else
        echo "Docker Compose is already installed."
    fi
}

# Execute Main Menu
main_menu
