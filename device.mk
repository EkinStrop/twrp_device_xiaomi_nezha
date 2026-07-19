#
# Device makefile for Xiaomi 17 Ultra (nezha) TWRP
#

DEVICE_PATH := device/xiaomi/nezha

# Configure base.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)

# Configure core_64_bit_only.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)

# Configure virtual_ab_ota compression_with_xor.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/compression_with_xor.mk)

# Configure emulated_storage.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Configure twrp config common.mk
$(call inherit-product, vendor/twrp/config/common.mk)

# API
# Match the Android 16 recovery runtime used by the working implementation.
BOARD_SHIPPING_API_LEVEL := 35
PRODUCT_SHIPPING_API_LEVEL := 35
PRODUCT_TARGET_VNDK_VERSION := 36

# Dynamic partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Enable Fuse Passthrough
PRODUCT_PROPERTY_OVERRIDES += persist.sys.fuse.passthrough.enable=true

# Recovery init
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/twrp.flags:recovery/root/system/etc/twrp.flags \
    $(DEVICE_PATH)/recovery/root/init.recovery.qcom.rc:recovery/root/init.recovery.qcom.rc \
    $(DEVICE_PATH)/recovery/root/init.recovery.wifi.rc:recovery/root/init.recovery.wifi.rc \
    $(DEVICE_PATH)/recovery/root/init.recovery.usb.rc:recovery/root/init.recovery.usb.rc \
    $(DEVICE_PATH)/recovery/root/system/bin/busybox:recovery/root/system/bin/busybox \
    $(DEVICE_PATH)/recovery/root/system/bin/dhcpcd:recovery/root/system/bin/dhcpcd \
    $(DEVICE_PATH)/recovery/root/system/bin/wpa_cli:recovery/root/system/bin/wpa_cli \
    $(DEVICE_PATH)/recovery/root/system/bin/nezha-dhcp.sh:recovery/root/system/bin/nezha-dhcp.sh \
    $(DEVICE_PATH)/recovery/root/system/bin/nezha-security-setup.sh:recovery/root/system/bin/nezha-security-setup.sh \
    $(DEVICE_PATH)/recovery/root/system/bin/nezha-wlan-setup.sh:recovery/root/system/bin/nezha-wlan-setup.sh \
    $(DEVICE_PATH)/recovery/root/system/bin/nezha-weaver-start.sh:recovery/root/system/bin/nezha-weaver-start.sh \
    $(DEVICE_PATH)/recovery/root/system/etc/resolv.conf:recovery/root/system/etc/resolv.conf \
    $(foreach ta,$(notdir $(wildcard $(DEVICE_PATH)/prebuilt/security/ta/*)),$(DEVICE_PATH)/prebuilt/security/ta/$(ta):recovery/root/system/bin/twrp_secure_element_ta/$(ta)) \
    $(DEVICE_PATH)/recovery/root/system/manifest.xml:recovery/root/system/manifest.xml \
    $(DEVICE_PATH)/recovery/root/vendor/manifest.xml:recovery/root/vendor/etc/vintf/manifest.xml \
    $(DEVICE_PATH)/recovery/root/vendor/etc/vintf/manifest/android.hardware.wifi.supplicant.xml:recovery/root/vendor/etc/vintf/manifest/android.hardware.wifi.supplicant.xml \
    $(DEVICE_PATH)/recovery/root/vendor/etc/vintf/manifest/vendor.qti.hardware.wifi.supplicant.xml:recovery/root/vendor/etc/vintf/manifest/vendor.qti.hardware.wifi.supplicant.xml \
    $(DEVICE_PATH)/recovery/root/vendor/etc/vintf/manifest/android.hardware.security.onekeymint-service-qti.xml:recovery/root/vendor/etc/vintf/manifest/android.hardware.security.onekeymint-service-qti.xml \
    $(DEVICE_PATH)/recovery/root/vendor/etc/vintf/manifest/android.hardware.vibrator-service.xml:recovery/root/vendor/etc/vintf/manifest/android.hardware.vibrator-service.xml \
    $(DEVICE_PATH)/recovery/root/vendor/etc/init/android.hardware.security.onekeymint-service-qti.rc:recovery/root/vendor/etc/init/android.hardware.security.onekeymint-service-qti.rc \
    $(DEVICE_PATH)/recovery/root/vendor/etc/init/nezha-weaver-chain.rc:recovery/root/vendor/etc/init/nezha-weaver-chain.rc \
    $(DEVICE_PATH)/recovery/root/vendor/etc/init/qseecomd.rc:recovery/root/vendor/etc/init/qseecomd.rc \
    $(DEVICE_PATH)/recovery/root/vendor/etc/init/vendor.xiaomi.hardware.vibratorfeature.service.rc:recovery/root/vendor/etc/init/vendor.xiaomi.hardware.vibratorfeature.service.rc \
    $(DEVICE_PATH)/recovery/root/vendor/etc/ueventd.rc:recovery/root/vendor/etc/ueventd.rc \
    $(DEVICE_PATH)/prebuilt/crypto/vendor/bin/hw/android.hardware.security.onekeymint-service-qti:recovery/root/vendor/bin/hw/android.hardware.security.onekeymint-service-qti \
    $(DEVICE_PATH)/prebuilt/crypto/vendor/bin/qseecomd:recovery/root/vendor/bin/qseecomd \
    $(DEVICE_PATH)/prebuilt/crypto/system/lib64/libbinder_ndk.so:recovery/root/system/lib64/libbinder_ndk.so \
    $(DEVICE_PATH)/prebuilt/crypto/vendor/etc/gpfspath_oem_config.xml:recovery/root/vendor/etc/gpfspath_oem_config.xml \
    $(foreach lib,android.hardware.common-V2-ndk.so libGPMTEEC_vendor.so libGPreqcancel.so libGPreqcancel_svc.so libQSEEComAPI.so libcxx.so libdiag.so libdmabufheap.so libdrm.so libdrmfs.so libdrmtime.so libgpt.so libops.so libqisl.so librpmb.so libseclog.so libspl.so libssd.so libtaautoload.so libtime_genoff.so libutils.so libxml2.so vendor.qti.hardware.display.config-V7-ndk.so,$(DEVICE_PATH)/prebuilt/crypto/vendor/lib64/$(lib):recovery/root/vendor/lib64/$(lib)) \
    $(DEVICE_PATH)/prebuilt/crypto/vendor/lib64/libminkdescriptor.so:recovery/root/vendor/lib64/libminkdescriptor.so \
    $(DEVICE_PATH)/prebuilt/crypto/vendor/lib64/libqcbor.so:recovery/root/vendor/lib64/libqcbor.so

# Nezha stock QTI secure-element, OMAPI and Thales Weaver chain used by Android 16 FBE.
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/prebuilt/security/vendor/bin/hlosminkdaemon:recovery/root/vendor/bin/hlosminkdaemon \
    $(DEVICE_PATH)/prebuilt/security/vendor/etc/ssg/ta_config.json:recovery/root/vendor/etc/ssg/ta_config.json \
    $(DEVICE_PATH)/prebuilt/security/vendor/bin/hw/android.hardware.secure_element-service.qti:recovery/root/vendor/bin/hw/android.hardware.secure_element-service.qti \
    $(DEVICE_PATH)/prebuilt/security/vendor/lib64/hw/libEseUtils.so:recovery/root/vendor/lib64/hw/libEseUtils.so \
    $(DEVICE_PATH)/prebuilt/security/odm/bin/hw/android.hardware.weaver-service.thales:recovery/root/vendor/odm/bin/hw/android.hardware.weaver-service.thales \
    $(DEVICE_PATH)/prebuilt/security/odm/bin/prepdecrypt.sh:recovery/root/vendor/odm/bin/prepdecrypt.sh \
    $(DEVICE_PATH)/prebuilt/security/odm/etc/init/prepdecrypt.rc:recovery/root/vendor/odm/etc/init/prepdecrypt.rc \
    $(DEVICE_PATH)/prebuilt/security/odm/etc/vintf/manifest/android.hardware.weaver-service.thales.xml:recovery/root/vendor/odm/etc/vintf/manifest/android.hardware.weaver-service.thales.xml \
    $(foreach lib,$(notdir $(wildcard $(DEVICE_PATH)/prebuilt/security/vendor/lib64/*.so)),$(DEVICE_PATH)/prebuilt/security/vendor/lib64/$(lib):recovery/root/vendor/lib64/$(lib)) \
    $(foreach lib,$(notdir $(wildcard $(DEVICE_PATH)/prebuilt/security/odm/lib64/*.so)),$(DEVICE_PATH)/prebuilt/security/odm/lib64/$(lib):recovery/root/vendor/odm/lib64/$(lib))

# Stock Xiaomi AIDL vibrator HAL
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/prebuilt/haptics/vendor/odm/bin/hw/vendor.xiaomi.hardware.vibratorfeature.service:recovery/root/vendor/odm/bin/hw/vendor.xiaomi.hardware.vibratorfeature.service \
    $(foreach lib,android.frameworks.sensorservice@1.0.so android.hardware.common.fmq-V1-ndk.so android.hardware.sensors@1.0.so android.hardware.sensors@2.0.so android.hardware.vibrator-V2-ndk.so libfmq.so libmisight.so libpalclient.so libsoc_helper.so libtinyalsa.so vendor.hardware.vibratorCL.impl.so vendor.hardware.vibratorfeature.IVibratorExt-V1-ndk.so vendor.qti.hardware.pal-V1-ndk.so,$(DEVICE_PATH)/prebuilt/haptics/vendor/odm/lib64/$(lib):recovery/root/vendor/odm/lib64/$(lib)) \
    $(DEVICE_PATH)/prebuilt/haptics/vendor/etc/HapticsPolicy.xml:recovery/root/vendor/etc/HapticsPolicy.xml \
    $(DEVICE_PATH)/prebuilt/haptics/vendor/etc/Hapticsconfig.xml:recovery/root/vendor/etc/Hapticsconfig.xml

# Required modules
TWRP_REQUIRED_MODULES += \
    prebuilt \
    task_profiles.json

# Recovery-native AIDL BootControl is required by update_engine_sideload when
# installing A/B HyperOS recovery OTAs.
PRODUCT_PACKAGES += \
    android.hardware.boot-service.default_recovery

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(DEVICE_PATH)
