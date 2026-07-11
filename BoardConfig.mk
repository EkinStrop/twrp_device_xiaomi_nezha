#
# TWRP device configuration for Xiaomi 17 Ultra (nezha)
# SoC: Qualcomm SM8850 "canoe" (Snapdragon 8 Elite 2)
#

# Building with minimal manifest
ALLOW_MISSING_DEPENDENCIES := true

# Rules
BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true
BUILD_BROKEN_NINJA_USES_ENV_VARS += RTIC_MPGEN
BUILD_BROKEN_PLUGIN_VALIDATION := soong-libaosprecovery_defaults soong-libguitwrp_defaults soong-libminuitwrp_defaults soong-vold_defaults
# BUILD_BROKEN_USES_SOONG_PYTHON2_MODULES removed - obsolete in twrp-16.0

DEVICE_PATH := device/xiaomi/nezha

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic

# Power
ENABLE_CPUSETS := true
ENABLE_SCHEDBOOST := true

# Bootloader
PRODUCT_PLATFORM := canoe
TARGET_BOOTLOADER_BOARD_NAME := $(PRODUCT_PLATFORM)
TARGET_NO_BOOTLOADER := true
TARGET_USES_UEFI := true

# Platform
TARGET_BOARD_PLATFORM := xiaomi_sm8850
TARGET_BOARD_PLATFORM_GPU := qcom-adreno840
QCOM_BOARD_PLATFORMS += xiaomi_sm8850

# Kernel - Prebuilt GKI 6.12
TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_HEADER_ARCH := arm64
BOARD_KERNEL_IMAGE_NAME := Image
BOARD_BOOT_HEADER_VERSION := 4
BOARD_KERNEL_PAGESIZE := 4096
TARGET_KERNEL_CLANG_COMPILE := true
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/kernel
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_PREBUILT_DTBIMAGE_DIR := $(DEVICE_PATH)/prebuilt
BOARD_PREBUILT_DTBOIMAGE := $(DEVICE_PATH)/prebuilt/dtbo.img
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_MKBOOTIMG_ARGS += --pagesize $(BOARD_KERNEL_PAGESIZE)
# Let build system set proper OS version (was 0.0.0 which may affect bootloader USB init)

# SELinux permissive for recovery
BOARD_KERNEL_CMDLINE += androidboot.selinux=permissive

# Ramdisk use lz4
BOARD_RAMDISK_USE_LZ4 := true

# A/B - no kernel in recovery (uses kernel from boot.img, matching stock behavior)
BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE := true

AB_OTA_UPDATER := true
AB_OTA_PARTITIONS += \
    boot \
    init_boot \
    vendor_boot \
    dtbo \
    vbmeta \
    vbmeta_system \
    odm \
    product \
    system \
    system_ext \
    system_dlkm \
    vendor \
    vendor_dlkm

# Verified Boot
BOARD_AVB_ENABLE := true
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3
BOARD_AVB_RECOVERY_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_RECOVERY_ALGORITHM := SHA256_RSA4096
BOARD_AVB_RECOVERY_ROLLBACK_INDEX := 1782864000
BOARD_AVB_RECOVERY_ROLLBACK_INDEX_LOCATION := 1

# Partitions
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true

# Workaround for error copying vendor files to recovery ramdisk
TARGET_COPY_OUT_VENDOR := vendor

TARGET_COPY_OUT_ODM := odm
BOARD_ODMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_USES_VENDOR_DLKMIMAGE := true
TARGET_COPY_OUT_VENDOR_DLKM := vendor_dlkm
BOARD_VENDOR_DLKMIMAGE_FILE_SYSTEM_TYPE := ext4

BOARD_RECOVERYIMAGE_PARTITION_SIZE := 104857600

# Dynamic Partition
BOARD_SUPER_PARTITION_SIZE := 15300820992
BOARD_SUPER_PARTITION_GROUPS := qti_dynamic_partitions
BOARD_QTI_DYNAMIC_PARTITIONS_SIZE := 15296626688
BOARD_QTI_DYNAMIC_PARTITIONS_PARTITION_LIST := system system_ext product vendor vendor_dlkm system_dlkm odm

# File systems
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true

# Extras
TARGET_SYSTEM_PROP += $(DEVICE_PATH)/system.prop

# Recovery
BOARD_HAS_LARGE_FILESYSTEM := true
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/recovery.fstab

# Crypto
TW_INCLUDE_CRYPTO := true
TW_INCLUDE_CRYPTO_FBE := true
TW_INCLUDE_FBE_METADATA_DECRYPT := true
TW_INCLUDE_OMAPI := true
BOARD_USES_QCOM_FBE_DECRYPTION := true
BOARD_USES_METADATA_PARTITION := true
TW_USE_FSCRYPT_POLICY := 2
PLATFORM_VERSION := 99.87.36
PLATFORM_VERSION_LAST_STABLE := $(PLATFORM_VERSION)
PLATFORM_SECURITY_PATCH := 2099-12-31
VENDOR_SECURITY_PATCH := 2099-12-31

# Tool
TW_INCLUDE_REPACKTOOLS := true
TW_INCLUDE_RESETPROP := true
TW_INCLUDE_LIBRESETPROP := true

# Debug
TARGET_USES_LOGD := true
TWRP_INCLUDE_LOGCAT := true
TARGET_RECOVERY_DEVICE_MODULES += debuggerd
RECOVERY_BINARY_SOURCE_FILES += $(TARGET_OUT_EXECUTABLES)/debuggerd
TARGET_RECOVERY_DEVICE_MODULES += strace
RECOVERY_BINARY_SOURCE_FILES += $(TARGET_OUT_EXECUTABLES)/strace
RECOVERY_LIBRARY_SOURCE_FILES += $(TARGET_OUT_SHARED_LIBRARIES)/android.hardware.vibrator-V2-ndk.so
RECOVERY_LIBRARY_SOURCE_FILES += $(TARGET_OUT_SHARED_LIBRARIES)/android.hardware.vibrator-V2-cpp.so

# Fastbootd
TW_INCLUDE_FASTBOOTD := true

# Other TWRP Configurations
TW_THEME := portrait_hdpi
TW_DEVICE_VERSION := JohnTheFarm3r
TW_FRAMERATE := 120
RECOVERY_SDCARD_ON_DATA := true
TARGET_RECOVERY_QCOM_RTC_FIX := true
TW_INCLUDE_NTFS_3G := true
TW_NO_EXFAT_FUSE := true
TW_NO_SCREEN_BLANK := true
TW_USE_DMCTL := true
TW_USE_TOOLBOX := true
TARGET_USES_MKE2FS := true
TW_INCLUDE_FUSE_EXFAT := true
TW_INCLUDE_FUSE_NTFS := true
TW_INPUT_BLACKLIST := "hbtp_vm"
TW_BRIGHTNESS_PATH := "/sys/devices/platform/soc/9800000.qcom,mdss_mdp/backlight/panel0-backlight/brightness"
TW_MAX_BRIGHTNESS := 16383
TW_DEFAULT_BRIGHTNESS := 4096
TW_EXTRA_LANGUAGES := true
TW_EXCLUDE_APEX := true
TW_HAS_EDL_MODE := true
TW_NO_HAPTICS := false
TW_SUPPORT_INPUT_AIDL_HAPTICS := true
TW_USE_SERIALNO_PROPERTY_FOR_DEVICE_ID := true
TW_SCREEN_BLANK_ON_BOOT := false
TW_LOAD_VENDOR_MODULES := "panel_event_notifier.ko gh_irq_lend.ko rproc_qcom_common.ko spf_core_dlkm.ko qti_battery_charger.ko adsp_loader_dlkm.ko xiaomi_touch.ko synaptics_tcm2.ko qcom-hv-haptics.ko stm_st54se_gpio.ko"
TW_LOAD_VENDOR_MODULES_EXCLUDE_GKI := true
TW_LOAD_PREBUILT_MODULES_AT_FIRST := true
TW_BACKUP_EXCLUSIONS := /data/fonts

# Statusbar
TW_STATUS_ICONS_ALIGN := center
