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
patch="$device_dir/patches/twrp-16/0001-vold-fix-synthetic-password-gcm.patch"

if git -C "$top/system/vold" apply --reverse --check "$patch" 2>/dev/null; then
    echo "Already applied: $(basename "$patch")"
else
    git -C "$top/system/vold" apply --check "$patch"
    git -C "$top/system/vold" apply "$patch"
    echo "Applied: $(basename "$patch")"
fi
