#!/system/bin/sh

slot="$(getprop ro.boot.slot_suffix)"

for attempt in 1 2 3 4 5 6 7 8 9 10; do
    if [ -e "/dev/block/by-name/modem${slot}" ]; then
        break
    fi
    sleep 1
done

mkdir -p /firmware /tmp/secure_element_fwroot/image /vendor/firmware_mnt /data/vendor/qwes
chmod 0755 /firmware /tmp/secure_element_fwroot /tmp/secure_element_fwroot/image /vendor/firmware_mnt /data/vendor/qwes
chown system system /data/vendor/qwes

mount -t vfat -o ro "/dev/block/by-name/modem${slot}" /firmware

# Match the proven recovery's firmware view. The modem filesystem has restrictive
# vfat modes in recovery, so stage its image and the secure-element trustlets in
# a normal ramdisk tree before any dependent HAL starts.
if [ -d /firmware/image ]; then
    cp -af /firmware/image/. /tmp/secure_element_fwroot/image/
fi
cp -af /system/bin/twrp_secure_element_ta/. /tmp/secure_element_fwroot/image/

for mapping in \
    'gpqese 32552B22-89FE-42B4-8A45-A0C4E2DB0326' \
    'st_eseservice FD719D50-FFFB-11EB-9A03-0242AC130003'; do
    set -- $mapping
    alias_name="$1"
    uuid_name="$2"
    for suffix in b00 b01 b02 b03 b04 b05 b06 b07 b08 mdt; do
        if [ -f "/tmp/secure_element_fwroot/image/${uuid_name}.${suffix}" ]; then
            cp -af "/tmp/secure_element_fwroot/image/${uuid_name}.${suffix}" \
                "/tmp/secure_element_fwroot/image/${alias_name}.${suffix}"
        fi
    done
done

chmod 0644 /tmp/secure_element_fwroot/image/* 2>/dev/null
mount --bind /tmp/secure_element_fwroot /vendor/firmware_mnt

setprop recovery.nezha.security_firmware_ready 1
start vendor.minkdaemon
