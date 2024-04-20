#!/usr/bin/bash
arg1="$1"
arg2="$2"

session(){
  if [ -z "$arg2" ]; then
        echo "parameter missing"
        exit 1
    fi
    
    if [ "$arg2" == "wayland" ]; then
        sed -i 's/WaylandEnable=false/#WaylandEnable=false/g' /etc/gdm/custom.conf
        echo "set Wayland session"
        reboot
    elif [ "$arg2" == "x11" ]; then
        sed -i 's/#WaylandEnable=false/WaylandEnable=false/g' /etc/gdm/custom.conf
        echo "set X11 session"
        reboot
    else
        echo "invalid parameter"
        exit 1
    fi
}

set_link(){
if [ -z "$arg2" ]; then
    echo "parameter missing"
    exit 1
fi
    cat > /home/kiosk/.local/bin/gnome-kiosk-script << CONFIG
#!/bin/sh
firefox -kiosk "$arg2"
sleep 1.0
exec "\$0" "\$@"
CONFIG
    chmod +x /home/kiosk/.local/bin/gnome-kiosk-script
    echo "Set kiosk: $arg2"
    killall firefox &> /dev/null
}

main () {
    if [ -z "$arg1" ]; then
        echo "parameter missing"
        exit 1
    fi

    if [ "$arg1" == "enable" ]; then
        sed -i 's/AutomaticLoginEnable=False/AutomaticLoginEnable=True/g' /etc/gdm/custom.conf
        echo "Kiosk enable"
        reboot
    elif [ "$arg1" == "disable" ]; then
        sed -i 's/AutomaticLoginEnable=True/AutomaticLoginEnable=False/g' /etc/gdm/custom.conf
        echo "Kiosk disable"
        reboot
    elif [ "$arg1" == "set" ]; then
        set_link
    elif [ "$arg1" == "session" ]; then
        session
    else
        echo "invalid parameter"
        exit 1
    fi
}

#Start program
is_root=$(whoami)
if [ ! $is_root == "root" ]; then
    echo "Please, run as root"
    exit 1
else
    main
    exit 0
fi
