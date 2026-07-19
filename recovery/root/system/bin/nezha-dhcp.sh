#!/system/bin/sh

case "$1" in
    deconfig)
        /system/bin/ifconfig "$interface" 0.0.0.0
        ;;
    bound|renew)
        /system/bin/ifconfig "$interface" "$ip" netmask "${subnet:-255.255.255.0}" up
        /system/bin/toybox route del default dev "$interface" >/dev/null 2>&1 || true
        if [ -n "$router" ]; then
            set -- $router
            /system/bin/toybox route add default gw "$1" dev "$interface"
        fi

        : > /etc/resolv.conf
        for nameserver in $dns; do
            echo "nameserver $nameserver" >> /etc/resolv.conf
        done
        ;;
esac
