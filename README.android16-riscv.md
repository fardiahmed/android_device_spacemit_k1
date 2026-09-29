# A16_RISCV/device/spacemit/k1: android16-riscv

Changes made for the Android 16 (AOSP, riscv64) bring-up of the BananaPi BPI-F3 (SpacemiT K1) and the BananaPi BPI-SM10 (SpacemiT K3), on branch `android16-riscv`.

BananaPi BPI-F3 (SpacemiT K1) device.

## Changes

- **k1: move the SoC-independent configuration to device/spacemit/common**: Prepare for more SpacemiT SoCs (K3): shared files and makefile blocks move to device/spacemit/common, the Mesa prebuilts to vendor/spacemit/hardware/mesa, the K1-only fstab, init scripts and GPU firmware move here, and optional features come from spacemit-features.mk. Android.mk rules only apply to K1 builds.
- **k1: load the USB3 combo PHY before dwc3**: In alphabetical order dwc3-spacemit loaded first and xHCI init timed out (-110): no onboard hub, no USB input.
- **k1: use the power-key-only recovery/fastbootd UI**: TARGET_RECOVERY_UI_LIB is librecovery_ui_k1 (vendor/spacemit/hardware/recovery): a short power press moves down, a long press selects. Recovery init restores sys.usb.configfs, sets the real UDC name and creates /dev/input for the late USB touchscreen; minui uses RGBX_8888 (its RGB565 fallback crashed).
- **k1: add a U-Boot splash screen**: logo.bmp is copied next to the images and flashed to the "logo" partition read by pi-u-boot.
- **k1: add a --boot mode to the flash script**: Flashes only the boot-side images and keeps super and userdata, for a warm boot when iterating on the kernel.
- **k1: boot at maximum CPU frequency**: Boot is CPU-bound: use the performance governor until boot completes, then schedutil. Restore full console logging after a SPACEMIT_QUIET_BOOT boot.
- **k1: enable Wi-Fi and Bluetooth on the RTL8852BS**: Realtek legacy Wi-Fi HAL (libwifi-hal-rtk from vendor/spacemit/hardware/wifi), supplicant APEX with the 8852bs overlays, the BT HCI HAL and the supplicant data directories.
- **k1: enable Wi-Fi Direct**: 8852bs.ko provides a dedicated P2P device and dynamic group interfaces, so P2P can run next to the STA connection.
- **k1: load the VPU driver at boot**: amvx has no usable modalias (space in its compatible), so nothing loaded it.
- **k1: wire the HDMI-CEC HAL**: SELinux domain and contexts for the AIDL tv.hdmi.cec / tv.hdmi.connection HAL (vendor/spacemit/hardware/hdmi) and access to the cec-gpio /dev/cec0 node.
- **k1: switch audio between HDMI and the built-in speakers**: persist.vendor.audio.hdmi_out 0/1 drives the HDMI audio jack state.
- **k1: match the ES8326 sound card name**: The card is now registered as BananaPiF3Audio.
- **k1: drop MIC_SWITCH from the ES8326 mixer controls**: "ALC Capture Switch" toggles automatic level control, not mute; the audio HAL now mutes capture itself.
- **k1: allow 8 MB UDP receive buffers**: A 1080p Miracast IDR frame overflowed the 256 KB default, causing packet loss and an IDR request loop.
- **k1: wire the header I2C4 sensors**: Load i2c-dev for the sensors HAL, label /dev/i2c-4 and the I2C4 sysfs nodes, and fix the i2c ueventd group (Android has no "i2c" group).
- **k1: note that Type-C sysfs uses the platform label**
- **k1: name the products "RISC V"**
- **k1: inherit early-overrides.mk first**: So device/spacemit/common's replacements of AOSP default files (preloaded-classes) win; PRODUCT_COPY_FILES is first-wins.
- **k1: give the KeyMint/Gatekeeper HALs and tee-supplicant the TEE devices**: /dev/tee0 and /dev/teepriv0 (OP-TEE driver) to system, the user of the OP-TEE KeyMint/Gatekeeper HALs and of tee-supplicant.
- **k1: leave the KeyMint/Gatekeeper selection to common**: The nonsecure APEX bootconfig is only needed without OP-TEE: SPACEMIT_OPTEE in device/spacemit/common decides.

## Notes

- Flash with `flash_bpi_f3.sh` (bootloader fastboot, slot a): vendor_boot, super, vbmeta, vbmeta_system_dlkm, vbmeta_vendor_dlkm; `--boot` keeps super/userdata.
- The HDMI-CEC HAL, Wi-Fi HAL and recovery UI sources are in vendor/spacemit/hardware/{hdmi,wifi,recovery}; this repository keeps their configuration.

## Build

```
./build.sh k1   # BPI-F3 (K1): kernel, bootloaders and Android images
./build.sh k3   # BPI-SM10 (K3), not booted yet
```

`./build.sh --help` lists the options (`--skip-kernel`, `--kernel-only`, ...).
