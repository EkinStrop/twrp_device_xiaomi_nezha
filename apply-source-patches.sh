#!/usr/bin/env bash
set -euo pipefail

device_dir="$(cd "$(dirname "$0")" && pwd)"
if [[ -n "${TWRP_TOP:-}" ]]; then
    top="$(cd "$TWRP_TOP" && pwd)"
elif [[ -d "$device_dir/../../../system/vold" ]]; then
    top="$(cd "$device_dir/../../.." && pwd)"
else
    echo "Set TWRP_TOP when running outside device/xiaomi/nezha" >&2
    exit 1
fi
apply_patch() {
    local project="$1"
    local patch="$2"

    if git -C "$top/$project" apply --reverse --check "$patch" 2>/dev/null; then
        echo "Already applied: $(basename "$patch")"
    else
        git -C "$top/$project" apply --check "$patch"
        git -C "$top/$project" apply "$patch"
        echo "Applied: $(basename "$patch")"
    fi
}

apply_patch system/vold \
    "$device_dir/patches/twrp-16/0001-vold-fix-synthetic-password-gcm.patch"
apply_patch bootable/recovery \
    "$device_dir/patches/twrp-16/0002-recovery-report-super-partition-size.patch"
apply_patch bootable/recovery \
    "$device_dir/patches/twrp-16/0003-recovery-fix-removable-storage-and-battery.patch"
apply_patch bootable/recovery \
    "$device_dir/patches/twrp-16/0004-recovery-wire-wlan-service-controls.patch"
apply_patch bootable/recovery \
    "$device_dir/patches/twrp-16/0005-recovery-remove-wlan-page-label.patch"
