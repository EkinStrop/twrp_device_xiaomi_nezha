#!/system/bin/sh

# The installed Lineage build uses the default QTI eSE1 + OMAPI + Thales
# Weaver path. TWRP mounts vendor_dlkm and loads the ST54 module while starting,
# so wait for its device node before probing the secure element.
timeout=20
while [ ! -e /dev/st54spi_gpio ] && [ "$timeout" -gt 0 ]; do
    sleep 1
    timeout=$((timeout - 1))
done

start vendor.secure_element
sleep 3
start se_omapi
sleep 2
start weaver_hal_service
sleep 2
start odm.prepdecrypt
