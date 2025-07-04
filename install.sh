#!/bin/bash

# HyprHue - AI-Powered Hyprland Theming Auto-Installer
# Copyright (C) 2025 HyprHue Project
# 
# This script installs and configures HyprHue, an AI-powered theming system
# for Hyprland on Arch-based distributions.
#
# Usage:
#   curl -sSL https://raw.githubusercontent.com/yourusername/hyprhue/main/install.sh | bash
#   curl -sSL https://raw.githubusercontent.com/yourusername/hyprhue/main/install.sh | bash -s -- --debug

set -euo pipefail

# Script information
SCRIPT_NAME="HyprHue Installer"
SCRIPT_VERSION="1.0.0"
REPO_URL="https://github.com/yourusername/hyprhue"
REPO_BRANCH="main"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Global variables
DEBUG=false
FORCE_INSTALL=false
SKIP_DEPENDENCIES=false
USER_HOME="${HOME}"
CONFIG_DIR="${USER_HOME}/.config"
CACHE_DIR="${USER_HOME}/.cache/hyprhue"
LOCAL_BIN_DIR="${USER_HOME}/.local/bin"
HYPRHUE_DIR="${CONFIG_DIR}/hyprhue"
LOG_FILE="${CACHE_DIR}/install.log"

# Logging functions
log() {
    echo -e "${1}" | tee -a "${LOG_FILE}"
}

log_info() {
    log "${CYAN}[INFO]${NC} ${1}"
}

log_success() {
    log "${GREEN}[SUCCESS]${NC} ${1}"
}

log_warning() {
    log "${YELLOW}[WARNING]${NC} ${1}"
}

log_error() {
    log "${RED}[ERROR]${NC} ${1}"
}

log_debug() {
    if [[ "${DEBUG}" == "true" ]]; then
        log "${PURPLE}[DEBUG]${NC} ${1}"
    fi
}

# Print header
print_header() {
    log ""
    log "${CYAN}╭─────────────────────────────────────────────────────╮${NC}"
    log "${CYAN}│                                                     │${NC}"
    log "${CYAN}│  ${WHITE}🎨 HyprHue - AI-Powered Hyprland Theming${CYAN}       │${NC}"
    log "${CYAN}│                                                     │${NC}"
    log "${CYAN}│  ${BLUE}Intelligent theming for Hyprland on Arch Linux${CYAN}  │${NC}"
    log "${CYAN}│                                                     │${NC}"
    log "${CYAN}╰─────────────────────────────────────────────────────╯${NC}"
    log ""
    log "${WHITE}Version:${NC} ${SCRIPT_VERSION}"
    log "${WHITE}Repository:${NC} ${REPO_URL}"
    log ""
}

# Parse command line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --debug)
                DEBUG=true
                log_debug "Debug mode enabled"
                shift
                ;;
            --force)
                FORCE_INSTALL=true
                log_debug "Force install mode enabled"
                shift
                ;;
            --skip-deps)
                SKIP_DEPENDENCIES=true
                log_debug "Skipping dependency installation"
                shift
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
}

# Show help
show_help() {
    log "${WHITE}Usage:${NC} $0 [OPTIONS]"
    log ""
    log "${WHITE}Options:${NC}"
    log "  --debug         Enable debug mode with verbose output"
    log "  --force         Force installation even if already installed"
    log "  --skip-deps     Skip dependency installation"
    log "  --help, -h      Show this help message"
    log ""
    log "${WHITE}Examples:${NC}"
    log "  $0"
    log "  $0 --debug"
    log "  $0 --force --debug"
    log ""
    log "${WHITE}One-line install:${NC}"
    log "  curl -sSL ${REPO_URL}/raw/${REPO_BRANCH}/install.sh | bash"
    log "  curl -sSL ${REPO_URL}/raw/${REPO_BRANCH}/install.sh | bash -s -- --debug"
}

# Check if running on Arch-based distribution
check_arch_distro() {
    log_info "Checking if running on Arch-based distribution..."
    
    if [[ ! -f /etc/arch-release ]] && [[ ! -f /etc/manjaro-release ]] && [[ ! -f /etc/endeavouros-release ]]; then
        if ! command -v pacman &> /dev/null; then
            log_error "This installer is designed for Arch-based distributions only."
            log_error "Detected distribution does not have pacman package manager."
            log_error "Supported distributions: Arch Linux, Manjaro, EndeavourOS, etc."
            exit 1
        fi
    fi
    
    log_success "Arch-based distribution detected"
}

# Check for NVIDIA GPU and warn user
check_nvidia_gpu() {
    log_info "Checking for NVIDIA GPU..."
    
    if lspci | grep -i nvidia &> /dev/null; then
        log_warning "NVIDIA GPU detected!"
        log_warning "NVIDIA GPUs may have compatibility issues with Hyprland."
        log_warning "You may experience screen tearing, flickering, or other issues."
        log_warning "Consider using proprietary drivers and additional configuration."
        log ""
        
        if [[ "${FORCE_INSTALL}" != "true" ]]; then
            read -p "Do you want to continue anyway? (y/N): " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                log_info "Installation cancelled by user."
                exit 0
            fi
        fi
    else
        log_success "No NVIDIA GPU detected"
    fi
}

# Check if Hyprland is installed
check_hyprland() {
    log_info "Checking if Hyprland is installed..."
    
    if ! command -v hyprctl &> /dev/null; then
        log_error "Hyprland is not installed!"
        log_error "Please install Hyprland first:"
        log_error "  yay -S hyprland"
        exit 1
    fi
    
    log_success "Hyprland is installed"
}

# Install yay-bin if not present
install_yay() {
    if command -v yay &> /dev/null; then
        log_debug "yay is already installed"
        return
    fi
    
    log_info "Installing yay-bin AUR helper..."
    
    # Create temporary directory
    local temp_dir=$(mktemp -d)
    cd "${temp_dir}"
    
    # Install git and base-devel if not present (required for AUR operations)
    sudo pacman -S --needed --noconfirm git base-devel
    
    # Download and install yay-bin (precompiled binary)
    log_debug "Downloading yay-bin from AUR..."
    git clone https://aur.archlinux.org/yay-bin.git
    cd yay-bin
    makepkg -si --noconfirm
    
    # Clean up
    cd "${USER_HOME}"
    rm -rf "${temp_dir}"
    
    log_success "yay-bin installed successfully"
}

# Install system dependencies
install_dependencies() {
    if [[ "${SKIP_DEPENDENCIES}" == "true" ]]; then
        log_info "Skipping dependency installation"
        return
    fi
    
    log_info "Installing system dependencies..."
    
    # Core packages
    local packages=(
        # Hyprland ecosystem
        "hyprland"
        "hyprpaper"
        "hyprlock"
        "hypridle"
        "xdg-desktop-portal-hyprland"
        
        # Waybar and components
        "waybar"
        "dunst"
        "rofi-wayland"
        "wofi"
        
        # Terminal emulators
        "kitty"
        "alacritty"
        
        # System tools
        "polkit-gnome"
        "thunar"
        "thunar-volman"
        "thunar-archive-plugin"
        "file-roller"
        "gvfs"
        "gvfs-mtp"
        "gvfs-gphoto2"
        "gvfs-smb"
        "gvfs-nfs"
        
        # Audio
        "pipewire"
        "pipewire-pulse"
        "pipewire-alsa"
        "pipewire-jack"
        "wireplumber"
        "pavucontrol"
        
        # Network
        "networkmanager"
        "network-manager-applet"
        "bluez"
        "bluez-utils"
        "blueman"
        
        # Fonts
        "ttf-jetbrains-mono"
        "ttf-font-awesome"
        "noto-fonts"
        "noto-fonts-emoji"
        "ttf-liberation"
        
        # Themes
        "papirus-icon-theme"
        "adwaita-icon-theme"
        "gtk3"
        "gtk4"
        "qt5ct"
        "qt6ct"
        
        # Screenshots
        "grimblast"
        "swappy"
        "grim"
        "slurp"
        
        # Clipboard
        "wl-clipboard"
        "cliphist"
        
        # System monitoring
        "btop"
        "htop"
        
        # Development tools
        "git"
        "curl"
        "wget"
        "jq"
        "python"
        "python-pip"
        "python-pillow"
        "python-requests"
        "python-colorthief"
        "python-numpy"
        
        # Media
        "mpv"
        "playerctl"
        "brightnessctl"
        
        # Other utilities
        "xdg-utils"
        "xdg-user-dirs"
        "unzip"
        "p7zip"
        "rsync"
    )
    
    log_debug "Installing packages: ${packages[*]}"
    
    # Update package database
    sudo pacman -Sy
    
    # Install packages
    yay -S --needed --noconfirm "${packages[@]}"
    
    log_success "System dependencies installed"
}

# Install and configure Ollama
install_ollama() {
    log_info "Installing and configuring Ollama..."
    
    # Install Ollama
    if ! command -v ollama &> /dev/null; then
        log_info "Installing Ollama..."
        yay -S --needed --noconfirm ollama
    fi
    
    # Start Ollama service
    sudo systemctl enable ollama
    sudo systemctl start ollama
    
    # Wait for Ollama to be ready
    log_info "Waiting for Ollama to be ready..."
    local retry_count=0
    while ! ollama list &> /dev/null; do
        if [[ $retry_count -gt 30 ]]; then
            log_error "Ollama failed to start after 30 seconds"
            exit 1
        fi
        sleep 1
        ((retry_count++))
    done
    
    # Pull vision-capable model
    log_info "Pulling vision-capable AI model (this may take a while)..."
    ollama pull llava:7b
    
    log_success "Ollama installed and configured"
}

# Create directory structure
create_directories() {
    log_info "Creating directory structure..."
    
    local dirs=(
        "${CONFIG_DIR}"
        "${CACHE_DIR}"
        "${LOCAL_BIN_DIR}"
        "${HYPRHUE_DIR}"
        "${USER_HOME}/Pictures/Screenshots"
        "${USER_HOME}/Pictures/Wallpapers"
        "${CONFIG_DIR}/hypr"
        "${CONFIG_DIR}/hypr/conf"
        "${CONFIG_DIR}/waybar"
        "${CONFIG_DIR}/kitty"
        "${CONFIG_DIR}/alacritty"
        "${CONFIG_DIR}/rofi"
        "${CONFIG_DIR}/dunst"
        "${CONFIG_DIR}/gtk-3.0"
        "${CONFIG_DIR}/gtk-4.0"
    )
    
    for dir in "${dirs[@]}"; do
        if [[ ! -d "${dir}" ]]; then
            mkdir -p "${dir}"
            log_debug "Created directory: ${dir}"
        fi
    done
    
    log_success "Directory structure created"
}

# Download and install configuration files
install_configs() {
    log_info "Installing configuration files..."
    
    # Create temporary directory for repo
    local temp_dir=$(mktemp -d)
    cd "${temp_dir}"
    
    # Clone repository
    git clone "${REPO_URL}.git" hyprhue
    cd hyprhue
    
    # Install Hyprland configs
    log_info "Installing Hyprland configuration..."
    cp -r configs/hyprland/* "${CONFIG_DIR}/hypr/"
    
    # Install Waybar configs
    log_info "Installing Waybar configuration..."
    cp -r configs/waybar/* "${CONFIG_DIR}/waybar/"
    
    # Install Kitty configs
    log_info "Installing Kitty configuration..."
    cp -r configs/kitty/* "${CONFIG_DIR}/kitty/"
    
    # Install Alacritty configs
    log_info "Installing Alacritty configuration..."
    cp -r configs/alacritty/* "${CONFIG_DIR}/alacritty/"
    
    # Install Rofi configs
    log_info "Installing Rofi configuration..."
    cp -r configs/rofi/* "${CONFIG_DIR}/rofi/"
    
    # Install Dunst configs
    log_info "Installing Dunst configuration..."
    cp -r configs/dunst/* "${CONFIG_DIR}/dunst/"
    
    # Install scripts
    log_info "Installing HyprHue scripts..."
    cp -r scripts/* "${LOCAL_BIN_DIR}/"
    chmod +x "${LOCAL_BIN_DIR}"/*
    
    # Install assets
    log_info "Installing sample assets..."
    cp -r assets/* "${USER_HOME}/Pictures/Wallpapers/"
    
    # Install configuration
    log_info "Installing HyprHue configuration..."
    cp config.toml "${HYPRHUE_DIR}/"
    
    # Clean up
    cd "${USER_HOME}"
    rm -rf "${temp_dir}"
    
    log_success "Configuration files installed"
}

# Create settings file
create_settings() {
    log_info "Creating HyprHue settings file..."
    
    cat > "${HYPRHUE_DIR}/config.toml" << EOF
# HyprHue Configuration File
# This file controls the behavior of the HyprHue AI theming system

[ai]
enabled = true
model = "llava:7b"
auto_mode = false
temperature = 0.7
timeout = 30

[apps]
waybar = true
kitty = true
alacritty = true
rofi = true
dunst = true
gtk = true
qt = true
hyprland = true

[behavior]
auto_reload = true
backup_configs = true
notification_level = "normal"
debug_mode = false

[paths]
wallpaper_dir = "${USER_HOME}/Pictures/Wallpapers"
screenshot_dir = "${USER_HOME}/Pictures/Screenshots"
backup_dir = "${CACHE_DIR}/backups"
theme_dir = "${HYPRHUE_DIR}/themes"

[colors]
preserve_contrast = true
min_contrast_ratio = 4.5
saturation_boost = 1.1
brightness_adjustment = 0.0

[ollama]
host = "http://localhost:11434"
model = "llava:7b"
timeout = 30
max_tokens = 1000
EOF
    
    log_success "Settings file created"
}

# Setup systemd services
setup_services() {
    log_info "Setting up systemd services..."
    
    # Create user service directory
    local service_dir="${CONFIG_DIR}/systemd/user"
    mkdir -p "${service_dir}"
    
    # Create HyprHue daemon service
    cat > "${service_dir}/hyprhue.service" << EOF
[Unit]
Description=HyprHue AI Theming Daemon
After=graphical-session.target

[Service]
Type=simple
ExecStart=${LOCAL_BIN_DIR}/hyprhue-daemon
Restart=on-failure
RestartSec=5
Environment=HOME=${USER_HOME}
Environment=XDG_CONFIG_HOME=${CONFIG_DIR}

[Install]
WantedBy=default.target
EOF
    
    # Enable services
    systemctl --user daemon-reload
    systemctl --user enable hyprhue.service
    
    log_success "Systemd services configured"
}

# Add to PATH
update_path() {
    log_info "Updating PATH..."
    
    # Add to shell profiles
    local shell_configs=(
        "${USER_HOME}/.bashrc"
        "${USER_HOME}/.zshrc"
        "${USER_HOME}/.config/fish/config.fish"
    )
    
    for config in "${shell_configs[@]}"; do
        if [[ -f "${config}" ]]; then
            if ! grep -q "${LOCAL_BIN_DIR}" "${config}"; then
                echo "export PATH=\"${LOCAL_BIN_DIR}:\$PATH\"" >> "${config}"
                log_debug "Added to PATH in ${config}"
            fi
        fi
    done
    
    log_success "PATH updated"
}

# Install cleanup
cleanup() {
    log_info "Cleaning up..."
    
    # Remove any temporary files
    if [[ -d "${temp_dir:-}" ]]; then
        rm -rf "${temp_dir}"
    fi
    
    log_success "Cleanup completed"
}

# Final setup and instructions
final_setup() {
    log_info "Performing final setup..."
    
    # Set executable permissions
    chmod +x "${LOCAL_BIN_DIR}"/hyprhue-*
    chmod +x "${LOCAL_BIN_DIR}"/theme-from-wallpaper
    
    # Create initial backup
    if [[ ! -d "${CACHE_DIR}/backups" ]]; then
        mkdir -p "${CACHE_DIR}/backups"
    fi
    
    log_success "Final setup completed"
}

# Print installation summary
print_summary() {
    log ""
    log "${GREEN}╭─────────────────────────────────────────────────────╮${NC}"
    log "${GREEN}│                                                     │${NC}"
    log "${GREEN}│  ${WHITE}🎉 HyprHue Installation Complete!${GREEN}              │${NC}"
    log "${GREEN}│                                                     │${NC}"
    log "${GREEN}╰─────────────────────────────────────────────────────╯${NC}"
    log ""
    log "${WHITE}Next steps:${NC}"
    log ""
    log "${CYAN}1.${NC} Restart your shell or run: ${WHITE}source ~/.bashrc${NC}"
    log "${CYAN}2.${NC} Start/restart Hyprland to load the new configuration"
    log "${CYAN}3.${NC} Try the theming system:"
    log "   ${WHITE}theme-from-wallpaper ~/Pictures/Wallpapers/sample.jpg${NC}"
    log "${CYAN}4.${NC} Use keybindings:"
    log "   ${WHITE}Super+T${NC} - Quick theme from wallpaper"
    log "   ${WHITE}Super+Shift+T${NC} - Theme selector"
    log ""
    log "${WHITE}Configuration files:${NC}"
    log "   ${WHITE}HyprHue:${NC} ${CONFIG_DIR}/hyprhue/config.toml"
    log "   ${WHITE}Hyprland:${NC} ${CONFIG_DIR}/hypr/hyprland.conf"
    log "   ${WHITE}Waybar:${NC} ${CONFIG_DIR}/waybar/"
    log "   ${WHITE}Logs:${NC} ${LOG_FILE}"
    log ""
    log "${WHITE}Documentation:${NC} ${REPO_URL}"
    log "${WHITE}Report issues:${NC} ${REPO_URL}/issues"
    log ""
    log "${YELLOW}Enjoy your AI-powered theming experience!${NC}"
}

# Main installation function
main() {
    # Create cache directory and log file
    mkdir -p "${CACHE_DIR}"
    touch "${LOG_FILE}"
    
    print_header
    parse_args "$@"
    
    log_info "Starting HyprHue installation..."
    log_debug "Debug mode: ${DEBUG}"
    log_debug "Force install: ${FORCE_INSTALL}"
    log_debug "Skip dependencies: ${SKIP_DEPENDENCIES}"
    log_debug "Log file: ${LOG_FILE}"
    
    # Perform installation steps
    check_arch_distro
    install_yay
    check_nvidia_gpu
    check_hyprland
    install_dependencies
    install_ollama
    create_directories
    install_configs
    create_settings
    setup_services
    update_path
    final_setup
    
    print_summary
    
    log_success "Installation completed successfully!"
    log_info "Log file saved to: ${LOG_FILE}"
}

# Trap cleanup on exit
trap cleanup EXIT

# Run main function with all arguments
main "$@" 