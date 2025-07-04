# Changelog

All notable changes to HyprHue will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial project structure and core functionality
- AI-powered wallpaper analysis using Ollama and LLaVA
- Comprehensive theming system for Hyprland ecosystem
- Modular configuration system for easy customization

## [1.0.0] - 2025-01-XX

### Added
- **Core Installation System**
  - One-line curl installer for Arch-based distributions
  - Automatic dependency detection and installation via yay
  - NVIDIA GPU compatibility warnings
  - Debug mode with comprehensive logging

- **AI Integration**
  - Ollama integration with vision-capable models
  - LLaVA 7B model support for wallpaper analysis
  - Natural language prompts for styling preferences
  - JSON-based theme data exchange format

- **Application Support**
  - Hyprland modular configuration with /conf subfolder structure
  - Waybar theming with CSS variable replacement
  - Kitty terminal theming
  - Alacritty terminal theming  
  - Rofi launcher theming
  - Dunst notification theming
  - GTK and Qt theme integration

- **Configuration Management**
  - TOML-based configuration file
  - Automatic backup system for existing configurations
  - Symlinked base configurations for easy maintenance
  - User-customizable settings and overrides

- **CLI Tools**
  - `theme-from-wallpaper` - Main theming command
  - `hyprhue-ai-analyze` - AI wallpaper analysis tool
  - `hyprhue-apply-theme` - Theme application engine
  - Sample wallpaper support with random selection

- **Hyprland Integration**
  - Modular configuration files in /conf subdirectory
  - Dynamic theme variables and color replacement
  - Workspace-specific theming options
  - Keybinding integration (Super+T, Super+Shift+T)

- **Developer Features**
  - Comprehensive error handling and logging
  - Debug mode with verbose output
  - Backup and restoration capabilities
  - Extensible script architecture

### Technical Details
- **Supported Distributions**: Arch Linux, Manjaro, EndeavourOS
- **AI Models**: LLaVA 7B (primary), extensible to other vision models
- **Configuration Format**: TOML with extensive customization options
- **Backup System**: Timestamped backups with restoration support
- **Logging**: Structured logging with multiple verbosity levels

### Requirements
- Arch-based Linux distribution with pacman
- yay AUR helper (auto-installed if missing)
- Hyprland window manager
- Non-NVIDIA GPU (AMD/Intel recommended)
- Internet connection for package installation and AI model download

### Installation
```bash
curl -sSL https://raw.githubusercontent.com/yourusername/hyprhue/main/install.sh | bash
```

### Usage Examples
```bash
# Apply theme from wallpaper
theme-from-wallpaper ~/Pictures/wallpaper.jpg

# Apply theme with natural language prompt
theme-from-wallpaper ~/Pictures/wallpaper.jpg "make it warm and cozy"

# Use random sample wallpaper
theme-from-wallpaper sample

# Use sample with styling prompt
theme-from-wallpaper sample "cyberpunk aesthetic"
```

### Breaking Changes
- N/A (initial release)

### Known Issues
- NVIDIA GPU compatibility limited due to Hyprland constraints
- Large AI models require significant disk space (7GB+ for LLaVA)
- Initial setup may take 10-15 minutes depending on internet speed

### Security Considerations
- All scripts run with user permissions (no root required after initial setup)
- AI processing happens locally via Ollama
- No external data transmission except for package downloads
- Configuration backups stored locally

### Performance Notes
- AI analysis typically takes 10-30 seconds depending on hardware
- Theme application is near-instantaneous
- Caching system reduces repeated analysis overhead
- Optimized for modern multi-core systems

## [Future Roadmap]

### Planned Features
- Additional AI model support (Phi-3 Vision, etc.)
- GUI theme picker and configuration editor
- Plugin system for additional applications
- Export/import theme functionality
- Automatic wallpaper change detection
- Cloud theme sharing (optional)
- Integration with popular wallpaper sources

### Under Consideration
- Support for other Linux distributions
- Integration with desktop environments beyond Hyprland
- Mobile companion app for remote theming
- Machine learning model fine-tuning
- Real-time color extraction from running applications 