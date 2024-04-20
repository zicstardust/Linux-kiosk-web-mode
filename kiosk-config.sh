#!/bin/bash
is_root=$(whoami)
if [ ! $is_root == "root" ]; then
    echo "Please, run as root"
    exit 1
fi

if [ -z "$1" ]; then
    echo "parameter missing"
    exit 1
fi

if [ "$1" == "enable" ]; then
    sed -i 's/AutomaticLoginEnable=False/AutomaticLoginEnable=True/g' /etc/gdm/custom.conf
    echo "Kiosk enable"
    exit 0
elif [ "$1" == "disable" ]; then
    sed -i 's/AutomaticLoginEnable=True/AutomaticLoginEnable=False/g' /etc/gdm/custom.conf
    echo "Kiosk disable"
    exit 0
fi

cat > /home/kiosk/.local/bin/gnome-kiosk-script << CONFIG
#!/bin/sh
firefox -kiosk "$1"
sleep 1.0
exec "\$0" "\$@"
CONFIG
chmod +x /home/kiosk/.local/bin/gnome-kiosk-script
echo "Set kiosk: $1"
exit 0
