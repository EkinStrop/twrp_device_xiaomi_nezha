#
# Product makefile for Xiaomi 17 Ultra (nezha) TWRP
#

DEVICE_PATH := device/xiaomi/nezha

# Inherit from device.mk configuration
$(call inherit-product, $(DEVICE_PATH)/device.mk)

## Device identifier
PRODUCT_DEVICE := nezha
PRODUCT_NAME := twrp_nezha
PRODUCT_BRAND := Xiaomi
PRODUCT_MODEL := 25128PNA1C
PRODUCT_MANUFACTURER := Xiaomi
