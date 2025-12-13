# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Overview

This is a ZMK firmware configuration repository for a Corne (crkbd) split keyboard with nice!nano v2 controllers. The configuration includes 4 layers with custom keymaps, mouse control support, combos, and macros. The firmware is built using Docker with the urob fork of ZMK to enable mouse key functionality.

## Build Commands

### Building Firmware

**Linux/Mac/WSL/Git Bash:**
```bash
./build.sh
```

**Windows:**
```bash
build.bat
```

Both scripts:
- Clone the urob fork of ZMK (https://github.com/urob/zmk) with mouse support
- Use Docker container `zmkfirmware/zmk-build-arm:stable`
- Compile firmware for both left and right sides
- Output: `corne_left.uf2` and `corne_right.uf2` in the project root

**Requirements:**
- Docker Desktop installed and running
- Internet connection (first build only)

**Build Process:**
1. Clones urob/zmk fork (supports `&mmv`, `&mkp`, `&msc` behaviors)
2. Initializes west workspace
3. Copies config files from `config/` directory
4. Compiles for `nice_nano_v2` board with `corne_left` and `corne_right` shields
5. Generates UF2 files ready for flashing

### Flashing

To flash the firmware to nice!nano:
1. Connect the nice!nano via USB
2. Double-tap the reset button to enter bootloader mode
3. A drive named "NICENANO" will appear
4. Copy the appropriate `.uf2` file to the drive
5. The board will automatically reboot with the new firmware

## Repository Structure

```
zmk-config/
├── config/
│   ├── corne.keymap    # Keymap definitions (layers, behaviors, combos, macros)
│   └── corne.conf      # Firmware configuration (features, sleep, bluetooth)
├── build.sh            # Build script for Linux/Mac/WSL
├── build.bat           # Build script for Windows
├── build.yaml          # CI build configuration (defines shields and boards)
├── west.yml            # West manifest (ZMK dependency management)
└── README.md           # Complete keyboard layout documentation (Portuguese)
```

## Architecture

### Configuration Files

**`config/corne.keymap`**
- Device tree format (.dtsi-based)
- Defines 4 keyboard layers (0-3)
- Custom behaviors: tap-preferred holds, mouse movement with acceleration
- Combos: Ctrl+C/V/Z/Y shortcuts, braces/parens insertion
- Macros: Insert braces with cursor positioning, comment lines, insert parentheses

**`config/corne.conf`**
- Kconfig format
- Enables: sleep mode, mouse pointing, combos, bluetooth
- Configures: sleep timeout (1 hour), idle timeout (30s), max BT connections (2)

**`west.yml`**
- Points to official zmkfirmware/zmk repository
- Build scripts override this by cloning urob fork instead

**`build.yaml`**
- Used by GitHub Actions (if set up)
- Defines matrix build: nice_nano_v2 board × {corne_left, corne_right} shields

### Layer Structure

- **Layer 0 (Default)**: QWERTY layout with mod-taps
  - `ALT/SPACE`: tap=ALT, hold=SPACE
  - `HYPER/ENTER`: tap=HYPER (Ctrl+Shift+Alt+GUI), hold=ENTER
  - Toggle keys activate Layer 1 and Layer 3

- **Layer 1 (Lower)**: Vim navigation + numbers
  - Numbers 0-9 on top row
  - Vim-style HJKL navigation
  - Toggle from Layer 0, can return with `&to 0`

- **Layer 2 (Raise)**: Numpad layout
  - Accessed via tap-preferred behavior (hold ENTER key)
  - 7-8-9 / 4-5-6 / 1-2-3 arrangement

- **Layer 3 (Mouse)**: Mouse control
  - Toggle-able layer
  - Arrow keys control mouse movement
  - Requires urob fork for `&mmv`, `&mkp`, `&msc` behaviors

### ZMK Behaviors Used

- `&kp`: Key press
- `&tp`: Custom tap-preferred hold-tap (150ms tapping term)
- `&tp2`: Custom tap-preferred for layer access
- `&tog`: Toggle layer on/off
- `&to`: Switch to layer permanently
- `&mo`: Momentary layer activation
- `&trans`: Transparent (pass-through to lower layer)
- `&mmv_accel1/2/3`: Mouse movement with different acceleration levels (urob fork)
- `&mkp_lclick/rclick`: Mouse button clicks (urob fork)

### Build System

**Docker-based Build:**
- Uses official ZMK build container for ARM
- Temporary workspace creation (Linux: `~/.zmk-cache`, Windows: `%TEMP%\zmk-build-*`)
- West build system orchestration
- Zephyr RTOS environment initialization

**Fork Details:**
- Official ZMK repository: https://github.com/zmkfirmware/zmk
- Used fork (build scripts): https://github.com/urob/zmk
- Fork includes mouse key support not yet in official ZMK main branch
- Note: The README states official ZMK now includes mouse support, but build scripts still use urob fork

## Development Workflow

### Modifying Keymaps

1. Edit `config/corne.keymap`:
   - Layers defined in `keymap` node
   - Each layer has a `bindings` array (36 keys total)
   - Key positions: 6 columns × 3 rows per side + 3 thumb keys per side
   
2. Key position matrix:
   ```
   Left side:              Right side:
   0   1   2   3   4   5   6   7   8   9   10  11
   12  13  14  15  16  17  18  19  20  21  22  23
   24  25  26  27  28  29  30  31  32  33  34  35
           36  37  38      39  40  41
   ```

3. After editing, run build script to compile

### Adding Combos

Combos are defined in the `combos` node:
```c
combo_name {
    bindings = <&kp DESIRED_KEY>;
    key-positions = <POS1 POS2>;  // Use position numbers above
    timeout-ms = <30>;
};
```

### Modifying Configuration

Edit `config/corne.conf` to:
- Enable/disable features (OLED, RGB, deep sleep)
- Adjust timeouts and power settings
- Configure Bluetooth pairing limits
- Must rebuild firmware after changes

### Testing Changes

1. Build firmware with build scripts
2. Check for compilation errors in Docker output
3. Flash to keyboard
4. Test keymap behavior
5. For debugging, check ZMK documentation for logging options

## Important Notes

### Mouse Keys
- Mouse functionality requires urob fork (build scripts handle this)
- Official ZMK mouse support status is unclear (README says yes, scripts use fork)
- Mouse behaviors: `&mmv` (move), `&mkp` (button), `&msc` (scroll)

### Bluetooth Profiles
- Keyboard supports 2 paired devices (configurable in corne.conf)
- Layer 2 would typically have BT profile switching (not visible in partial keymap read)

### Sleep Configuration
- Idle timeout: 30 seconds (screen/features turn off)
- Sleep timeout: 1 hour (deep sleep, wake by pressing any key)
- Extends battery life significantly

### File Encoding
- All configuration files use UTF-8
- Device tree files (.keymap, .dtsi) use C-style syntax
- Comments use `//` or `/* */`

## Common Issues

### Build Failures
- **Docker not running**: Start Docker Desktop
- **Permission errors**: Ensure Docker has file system access
- **Network issues**: First build requires internet to clone ZMK

### Flash Issues
- **Board not detected**: Double-tap reset button on nice!nano
- **Wrong file flashed**: Ensure left UF2 goes to left side, right to right side
- **Keyboard not working**: Verify both sides are flashed with correct firmware

### Keymap Issues
- **Key not working**: Check key position numbers in bindings array
- **Layer not activating**: Verify layer toggle/momentary keys
- **Combo not triggering**: Adjust timeout-ms or check key positions

## References

- ZMK Official Documentation: https://zmk.dev/docs
- Urob ZMK Fork: https://github.com/urob/zmk
- nice!nano: https://nicekeyboards.com/nice-nano/
- Corne Keyboard: https://github.com/foostan/crkbd
- README.md contains complete Portuguese documentation of all layers and features
