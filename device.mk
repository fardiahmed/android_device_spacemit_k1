#
# Copyright (C) 2024 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#

# SpacemiT K1: BananaPi F3. Shared parts are in device/spacemit/common; every SPACEMIT_*
# feature is supported, so the spacemit-features.mk defaults apply.

# Inherit common
$(call inherit-product, device/spacemit/common/device-common.mk)

# Vendor firmware
$(call inherit-product, vendor/spacemit/k1/k1.mk)

# Platform
PRODUCT_PLATFORM := k1

# Kernel
TARGET_KERNEL_USE ?= mainline
LOCAL_KERNEL := device/spacemit/k1-kernel/$(TARGET_KERNEL_USE)/Image

PRODUCT_COPY_FILES += \
    $(LOCAL_KERNEL):kernel

# Properties
PRODUCT_PROPERTY_OVERRIDES += \
    ro.hardware.gralloc=minigbm \
    sys.usb.configfs=1 \
    sys.usb.controller=mv-udc \
    persist.vendor.audio.primary.card_name=BananaPi-F3-Audio \
    persist.vendor.audio.primary.card=0 \
    persist.vendor.audio.primary.device=0 \
    persist.vendor.audio.mixer.config=/vendor/etc/mixer_controls.xml \
    vendor.thermal.hardware=spacemit \
    vendor.hwc.drm.internal_display_names=HDMI-A-1 \
    ro.vendor.boot_security_patch=2025-01-05 \
    config.disable_renderscript=true \
    ro.vendor.hwc.use_overlay_planes=true \
    ro.sf.lcd_density=240

# Audio mixer controls (BPI-F3 / ES8326B codec)
PRODUCT_COPY_FILES += \
    device/spacemit/k1/audio/mixer_controls.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_controls.xml

# Fstab
PRODUCT_PACKAGES += \
    fstab.k1 \
    fstab.k1.vendor_ramdisk

# Init
PRODUCT_COPY_FILES += \
    device/spacemit/k1/init.k1.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.k1.rc \
    device/spacemit/k1/init.k1.usb.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.k1.usb.rc \
    device/spacemit/k1/ueventd.k1.rc:$(TARGET_COPY_OUT_VENDOR)/etc/ueventd.rc

# GPU firmware (PowerVR)
PRODUCT_COPY_FILES += \
    device/spacemit/k1/firmware/powervr/rogue_36.29.52.182_v1.fw:$(TARGET_COPY_OUT_VENDOR)/firmware/powervr/rogue_36.29.52.182_v1.fw

# Soong namespace of this directory (fstab, recovery UI, HDMI-CEC HAL, Wi-Fi HAL/supplicant)
PRODUCT_SOONG_NAMESPACES += \
    device/spacemit/k1

# Optional features (SPACEMIT_*): must come last, after the defaults above.
$(call inherit-product, device/spacemit/common/spacemit-features.mk)
