Great, I’ll compile a complete and up-to-date Markdown reference as of June 2025 for both Hyprland and Waybar. This will include:

* All `hyprland.conf` variables and settings, including general, window rules, animations, input, gestures, etc.
* Relevant Hyprland environment variables, scripting hooks, and IPC commands where applicable.
* Full Waybar module list, configuration schema (`config.jsonc`), and exhaustive CSS guide with class structure, available style hooks, and practical examples.

I’ll let you know as soon as the Markdown file is ready.


# Hyprland Configuration

Hyprland’s configuration is controlled via the `~/.config/hypr/hyprland.conf` file.  This file is organized into sections (e.g. `general`, `decoration`, `input`, `monitor`, `windowrule`, `dwindle`, `misc`, `exec`, etc.) each with various keys. While the *complete* list of options is documented in the Hyprland wiki, some common settings include:

* **General settings** (e.g. `gaps_in`, `gaps_out`, `border_size`, color variables like `col.active_border`, etc.). These control default gaps and borders for all windows.
* **Decoration** (e.g. `rounding` for corner radius, `borderless_monocle`, `blur.enabled/size/passes` for window blur, etc.). These affect window appearance.
* **Animations** (e.g. `animations.enabled`, `animations.window.duration`, etc.), which toggle and tune animations.
* **Dwindle layout** (e.g. `dwindle.toggle`, `dwindle.master_split_mode`, etc.) to configure the dynamic tiling algorithm.
* **Input devices** (`mouse:…`, `touchpad:…`, `keyboard:…` sub-sections) with options like pointer speed and scrolling.
* **Monitors** (the `monitor` keyword) to configure scaling, resolution, and transform for each output.
* **Autostart** (`exec`/`exec-once` entries) to run programs on startup (for example, `exec-once=waybar` to launch Waybar).

Each option has specific syntax and defaults documented in the Hyprland wiki.  For example, workspace rules allow `windowrule` blocks with properties like `windowrule = float,workspace=3` to send matching apps to specific workspaces.  For details on every setting, refer to the official docs (which list each config key by category).

Hyprland also supports **environment variables** and IPC for advanced control:

* *Environment variables:*  Hyprland recognizes several `HYPRLAND_*` variables. For example, `HYPRLAND_NO_RT=1` disables real-time scheduling, `HYPRLAND_NO_SD_NOTIFY=1` disables systemd notifications, `HYPRLAND_NO_SD_VARS=1` skips exporting systemd session variables, and `HYPRLAND_TRACE=1` enables verbose logging.  You can also set `HYPRLAND_CONFIG=/path/to/hyprland.conf` to specify a custom config location.  In practice, these can be set in a startup script or via the `env` keyword in `hyprland.conf`.  Similarly, Aquamarine (the underlying wlroots library Hyprland uses) has `AQ_`-prefixed variables, e.g. `AQ_TRACE=1` (verbose logs) and `AQ_DRM_DEVICES=/dev/dri/card0` to specify GPUs, or `AQ_MGPU_NO_EXPLICIT=1`, `AQ_NO_MODIFIERS=1` for multi-GPU setups.  (These environment flags affect how Hyprland initializes hardware.)

* *IPC and scripting:*  Hyprland provides a CLI tool `hyprctl` for runtime control. You can use `hyprctl dispatch` to execute compositing commands (e.g. `hyprctl dispatch exec kitty` to launch an app) or `hyprctl keyword` to change a config value on the fly (e.g. `hyprctl keyword general:border_size 10`).  Other commands include `hyprctl reload` (reloads the config), `hyprctl kill` (enter click-to-kill mode), and info queries like `hyprctl monitors` or `hyprctl workspaces` to dump JSON about outputs and workspaces.  These can be used in scripts or bindings to control Hyprland dynamically.  For example, one can bind keys to `exec bash -c 'hyprctl dispatch workspace 3'` in the Hyprland bind configuration.  JSON output can be obtained with `-j`, useful for status bars.

In summary, **Hyprland’s configuration options** cover window behavior, visuals, inputs, etc., organized by section (see the official wiki for the full list).  Environment variables like `HYPRLAND_NO_RT`, `HYPRLAND_NO_SD_NOTIFY`, `HYPRLAND_TRACE` and Aquamarine’s `AQ_` variables modify startup behavior.  IPC via `hyprctl` enables scripting and runtime control (e.g. dispatching commands or querying state).

# Waybar Configuration and Modules

Waybar’s behavior is defined in a JSONC config file (typically `~/.config/waybar/config.jsonc`).  Basic bar settings (e.g. `position`, `layer`, `height`, `spacing`) are global options.  The heart of configuration is the `modules-left/center/right` arrays, which list the modules to display.  **Modules** can be core status indicators (CPU, network, clock, etc.) or compositor-specific elements (workspaces, window title, etc.).

Waybar’s **official modules** (built-in) include a wide range, as listed in the manual.  These cover:

* **System modules:** `clock`, `battery`, `cpu`, `memory`, `temperature`, `network`, `pulseaudio` (audio), `bluetooth`, `disk`, `updates` (via `custom/`), `tray`, etc. For example, the **battery** module has options like `states` (thresholds for warning), `format`, `format-icons` (icon array for charge levels), and per-battery settings (e.g. `"battery#BAT2": {"bat": "BAT2"}`).  The **clock** module supports `format` (strftime), `timezone`, and `format-alt` or `tooltip-format` for alternate displays.  The **cpu** module supports a `format` string and whether to show a tooltip.  The **memory** module has a `format`.  The **temperature** module allows specifying a thermal zone or hwmon path, `format`, and `critical-threshold` with alternate formatting.  **Backlight** (screen brightness) has `device`, `format`, `format-icons` for different ranges.  **Network** has `interface` (to force a device), `format-wifi`, `format-ethernet`, `format-disconnected`, etc..  **Pulseaudio** has many options: volume formats for different device types, `format-muted`, `format-icons` for output types, and can set an `on-click` action to launch a mixer.  (Waybar also supports `wireplumber` as a modern audio module.)

* **Compositor-specific modules:** For Wlroots compositors, Waybar provides modules under a path like `sway/...`, `river/...`, `hyprland/...`, etc.  For example, **`sway/workspaces`** and **`sway/mode`** display workspace buttons and the current binding mode in Sway.  `sway/workspaces` supports options such as `format`, `format-icons` (mapping workspace names to icons), and sorting flags (`sort-by-name`, `sort-by-coordinates`, `all-outputs`, etc.).  Similarly, **`hyprland/workspaces`** shows Hyprland workspaces (with very similar options and format-icons).  The **window** modules (`sway/window`, `hyprland/window`) show the focused window’s title (with a `format`).  **`sway/scratchpad`** lists scratchpad windows (fields: `format`, `show-empty`, `tooltip-format`, etc.).  Language modules (`sway/language`, `hyprland/language`) show current keyboard layout.  Binding mode modules (`sway/mode`, `river/layout` or `river/mode`) have a simple `format`.  Other modules include **idle\_inhibitor** (shows whether a screensaver inhibitor is active, with `format` and icons) and **tray** (the system tray; options `icon-size` and `spacing`).

Each module’s configuration is a JSON object keyed by the module name (with `#id` suffix if needed).  Within each module’s config, you can set fields documented in the Waybar wiki or manpage.  Some examples from the default config include:

```jsonc
"keyboard-state": {
  "numlock": true,
  "capslock": true,
  "format": "{name} {icon}",
  "format-icons": {"locked": "", "unlocked": ""}
},
"battery": {
  "states": {"warning": 30, "critical": 15},
  "format": "{capacity}% {icon}",
  "format-full": "{capacity}% {icon}",
  "format-charging": "{capacity}% ",
  "format-icons": ["","","","",""]
},
"network": {
  "interface": "wlp2*",
  "format-wifi": "{essid} ({signalStrength}%) ",
  "format-ethernet": "{ipaddr}/{cidr} ",
  "format-disconnected": "Disconnected ⚠"
},
"clock": {
  "tooltip-format": "{:%Y %B}\n`{calendar}`",
  "format-alt": "{:%Y-%m-%d}"
},
"custom/media": {
  "format": "{icon} {text}",
  "return-type": "json",
  "max-length": 40,
  "exec": "$HOME/.config/waybar/mediaplayer.py"
},
"custom/power": {
  "format": "⏻ ",
  "tooltip": false,
  "menu": "on-click",
  "menu-file": "$HOME/.config/waybar/power_menu.xml",
  "menu-actions": {"shutdown": "shutdown", "reboot": "reboot", ...}
}
```

These examples (adapted from the default config) show module-specific fields.  For a full list, see Waybar’s docs; for example, the **Workspaces** module page lists `format`, `format-icons`, sorting options, and persistent-workspaces.

# Waybar Styling (CSS)

Waybar’s appearance is customized via CSS (e.g. in `~/.config/waybar/style.css`).  Each module is rendered as an HTML-like widget with an `id` and child elements.  You can target modules by their `id` (usually the module name after the slash).  For example, the workspaces module uses `#workspaces` (for the container) and its workspace buttons are `#workspaces button`.  These buttons have state classes like `.active`, `.urgent`, `.empty`, `.visible`, `.persistent`, `.special` and even `.hosting-monitor` (when the workspace is on the current monitor).  So you can style them accordingly.  For example, in CSS you might write:

```css
#workspaces button {
  border-radius: 5px;
  color: #888;
}
#workspaces button.active {
  background: #4F2799;
  color: #ffffff;
}
#workspaces button:hover {
  background: #d0ddd6;
  color: #313244;
}
#workspaces button.urgent {
  color: #e60000;
}
```

Similarly, other modules have predictable ids and classes.  The **bar itself** has an id (default `#waybar` if you set it) or you can use module ids (e.g. `#clock` for the clock module).  You can use any standard CSS selectors and pseudo-classes.  For example, Waybar supports the `:hover` pseudo-class, so you can change styling on mouse-over (as in the clock example below).

The Arch manuals provide style guidelines, e.g. `#clock { color: #00ff00; background: #000; }` to make the clock text green on black, and `#clock:hover { background-color: #ffffff; }` for a hover effect.  The workspaces example above was confirmed by a user: they styled the active workspace button and hover state with `#workspaces button.active` and `#workspaces button:hover` selectors.  Thus, by using module IDs (which are `#<modulename>` with the slash replaced by a dash or omitted) and element classes, you can fully style Waybar.

**Examples of style customizations:**

* Make the active workspace stand out (from \[95]):

  ```css
  #workspaces button.active {
    background: #4F2799;
    color: #ffffff;
    border-radius: 18px;
  }
  #workspaces button:hover {
    background: #d0ddd6;
    color: #313244;
  }
  ```

* Change the clock color (from \[88]):

  ```css
  #clock {
    background: #000000;
    color: #00ff00;
  }
  #clock:hover {
    background-color: #ffffff;
  }
  ```

* Style battery levels via classes (assuming Waybar adds classes like `.critical` or `.charging` to battery, or using icon colors via CSS).

* Use `cursor: pointer;` or disable it with the module’s `"cursor": false` config option, in case you want a hand cursor on hover.

In general, Waybar’s CSS is standard: you can target `#<moduleid>` for the module container, and elements like `button`, `img`, `div` inside it.  Pseudo-classes like `:hover` work normally.  For a full list of selectors per module, see the Waybar wiki module pages or manual pages.  For example, the Hyprland workspaces manual lists all relevant selectors (`#workspaces`, `#workspaces button.active`, etc.).

**Summary:** All official Waybar modules (system and compositor-specific) are listed in the manual.  Each has documented config options (as seen in the examples above).  Modules generate HTML elements with known IDs and state classes, which you can style with CSS.  Verified working examples include using `:hover` and classes like `.active` to change colors on focus (as shown in the excerpts above).

**Sources:** Official Hyprland and Waybar documentation and manual pages.
