#!/system/bin/sh

log_message() {
    echo "I:nezha-wlan-setup: $1" >> /tmp/recovery.log
}

if [ "$(getprop ro.twrp.fastbootd)" = "1" ]; then
    log_message "Skipping WLAN setup in fastbootd"
    exit 0
fi

attempt=0
while [ "$attempt" -lt 30 ]; do
    for partition in vendor vendor_dlkm system_dlkm odm persist; do
        if ! mount | grep -q " on /${partition} "; then
            mount "/${partition}" >/dev/null 2>&1 || true
        fi
    done

    if [ -x /vendor/bin/hw/wpa_supplicant ] && [ -f /vendor_dlkm/lib/modules/qca_cld3_peach_v2.ko ]; then
        break
    fi

    sleep 1
    attempt=$((attempt + 1))
done

if [ ! -x /vendor/bin/hw/wpa_supplicant ] || [ ! -f /vendor_dlkm/lib/modules/qca_cld3_peach_v2.ko ]; then
    log_message "Required Nezha WLAN files are unavailable"
    setprop nezha.wlan.status missing-files
    exit 1
fi

mkdir -p /system/lib
if [ ! -e /system/lib/modules ]; then
    ln -s /system_dlkm/lib/modules /system/lib/modules
fi

mkdir -p /tmp/recovery/sockets
chown 1010:1010 /tmp/recovery/sockets
chmod 0775 /tmp/recovery
chmod 0770 /tmp/recovery/sockets

# The modem firmware is staged before TWRP mounts vendor. Restore that staged
# view after the vendor mount so the CNSS firmware loader can reach it.
if [ -d /tmp/secure_element_fwroot/image ]; then
    chmod -R a+rX /tmp/secure_element_fwroot
    mount --bind /tmp/secure_element_fwroot /vendor/firmware_mnt
fi

if [ -w /sys/module/firmware_class/parameters/path ]; then
    echo /vendor/firmware_mnt/image > /sys/module/firmware_class/parameters/path
fi

if [ -e /proc/sys/kernel/firmware_config/force_sysfs_fallback ]; then
    echo 1 > /proc/sys/kernel/firmware_config/force_sysfs_fallback
fi

if [ -e /sys/kernel/icnss/wlan_en_delay ]; then
    echo 1000 > /sys/kernel/icnss/wlan_en_delay
fi

if [ -e /sys/kernel/icnss/wpss_boot ]; then
    echo 1 > /sys/kernel/icnss/wpss_boot
fi

setprop ctl.start nezha-pd-mapper
setprop ctl.start nezha-pm-proxy
setprop ctl.start nezha-pm-service
setprop ctl.start nezha-qrtr-ns
setprop ctl.start nezha-rmt-storage
setprop ctl.start nezha-tftp-server
setprop ctl.start nezha-cnss-daemon

modprobe -d /vendor/lib/modules cnss2 >> /tmp/recovery.log 2>&1 || {
    log_message "Failed to load the CNSS platform driver"
    setprop nezha.wlan.status cnss-failed
    exit 1
}

count=0
while [ ! -e /sys/kernel/cnss/fs_ready ] && [ "$count" -lt 10 ]; do
    sleep 1
    count=$((count + 1))
done

if [ -e /sys/kernel/cnss/fs_ready ]; then
    echo 1 > /sys/kernel/cnss/fs_ready
    if [ -e /sys/kernel/cnss/recovery ]; then
        echo 3 > /sys/kernel/cnss/recovery
    fi
else
    log_message "CNSS firmware-ready control did not appear"
    setprop nezha.wlan.status cnss-not-ready
    exit 1
fi

modprobe -d /vendor/lib/modules qca_cld3_peach_v2 >> /tmp/recovery.log 2>&1 || {
    log_message "Failed to load the Peach WLAN driver"
    setprop nezha.wlan.status driver-failed
    exit 1
}

count=0
while [ ! -e /sys/class/net/wlan0 ] && [ "$count" -lt 15 ]; do
    sleep 1
    count=$((count + 1))
done

if [ ! -e /sys/class/net/wlan0 ]; then
    log_message "wlan0 did not appear"
    setprop nezha.wlan.status interface-missing
    exit 1
fi

ifconfig wlan0 up
setprop ctl.start nezha-wpa-supplicant
setprop nezha.wlan.status ready
log_message "WLAN is ready"
