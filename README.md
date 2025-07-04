# HyprHue - AI-Powered Hyprland Theming Auto-Installer

**🎨 Intelligent theming for Hyprland on Arch Linux**

HyprHue is a curl-and-run auto-installer that sets up an AI-powered theming environment for Hyprland users. It automatically installs dependencies, configures a local LLM with vision capabilities, and provides seamless desktop theming from wallpapers using natural language prompts.

## 🚀 Quick Start

**One-line install:**
```bash
curl -sSL https://raw.githubusercontent.com/yourusername/hyprhue/main/install.sh | bash
```

**Debug mode:**
```bash
curl -sSL https://raw.githubusercontent.com/yourusername/hyprhue/main/install.sh | bash -s -- --debug
```

## ✨ Features

- **AI-Powered Theming**: Extract color palettes from wallpapers using local LLM
- **One-Command Setup**: Complete installation with a single curl command
- **Vision-Capable AI**: Uses models like `llava` for intelligent color analysis
- **Modular Configuration**: Pre-configured base files for all supported applications
- **Smart Reloading**: Automatically reloads affected applications after theme changes
- **Natural Language**: Apply themes with descriptive prompts
- **Arch-Optimized**: Built specifically for Arch-based distributions

## 🎯 Supported Applications

- **Waybar**: Status bar theming
- **Kitty**: Terminal emulator themes
- **Alacritty**: Alternative terminal themes
- **Rofi/Wofi**: Application launcher themes
- **Dunst/Mako**: Notification daemon themes
- **GTK**: System-wide GTK themes
- **Qt5ct/Qt6ct**: Qt application themes

## 📋 Requirements

- **Arch-based distribution** (Arch Linux, Manjaro, EndeavourOS, etc.)
- **Hyprland** window manager
- **yay** AUR helper (will be installed if missing)
- **NVIDIA GPU Warning**: The installer will warn and exit on NVIDIA systems

## 🛠️ Usage

After installation, use the CLI command:

```bash
# Apply theme from wallpaper
theme-from-wallpaper ~/Pictures/wallpaper.jpg

# Apply theme with natural language prompt
theme-from-wallpaper ~/Pictures/wallpaper.jpg "make it warm and cozy"

# Use sample wallpapers
theme-from-wallpaper sample "cyberpunk aesthetic"
```

## ⚙️ Configuration

Settings are stored in `~/.config/hyprhue/config.toml`:

```toml
[ai]
enabled = true
model = "llava"
auto_mode = false

[apps]
waybar = true
kitty = true
rofi = true
dunst = true
gtk = true

[behavior]
auto_reload = true
backup_configs = true
```

## 📁 Project Structure

```
hyprhue/
├── install.sh              # Main installer script
├── configs/                 # Base configuration files
│   ├── waybar/
│   ├── kitty/
│   ├── rofi/
│   └── ...
├── scripts/                 # Core functionality scripts
├── assets/                  # Sample wallpapers and resources
└── docs/                    # Documentation
```

## 🔧 Development

- **Modular Design**: Each component is in its own script
- **Version Control**: All configurations tracked in Git
- **Extensible**: Easy to add new applications and themes
- **Debugging**: Full debug logging available with `--debug` flag

## 📝 Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history and updates.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test on a clean Arch installation
5. Submit a pull request

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

## ⚠️ Disclaimer

This tool modifies system configurations. Always backup your existing configs before running the installer. 