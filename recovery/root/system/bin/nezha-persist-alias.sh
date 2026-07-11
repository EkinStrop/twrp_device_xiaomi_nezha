#!/system/bin/sh

for attempt in 1 2 3 4 5 6 7 8 9 10; do
    if mount | grep -q ' on /mnt/vendor/persist '; then
        break
    fi
    sleep 1
done

if mount | grep -q ' on /mnt/vendor/persist '; then
    if ! mount | grep -q ' on /persist '; then
        rm -rf /persist
        ln -s /mnt/vendor/persist /persist
    fi
fi
