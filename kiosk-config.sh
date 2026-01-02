#!/usr/bin/bash
arg1="$1"
arg2="$2"
arg3="$3"

help(){
    cat > /tmp/kiosk-config << HELP
LINUX KIOSK MODE
How to use:

kiosk-config set "<YOUR URL HERE>"
kiosk-config set "<YOUR URL HERE>" --chrome
kiosk-config set "<YOUR URL HERE>" --chromium
    Set kiosk URL

kiosk-config enable
kiosk-config on
    Enable autologin kiosk user

kiosk-config disable
kiosk-config off
    Disable autologin kiosk user

kiosk-config session x11
    Kiosk in X11 session

kiosk-config session wayland
    Kiosk in Wayland session

HELP
    cat /tmp/kiosk-config
    rm -f /tmp/kiosk-config
}

session(){
  if [ -z "$arg2" ]; then
        echo "parameter missing"
        exit 1
    fi
    
    if [ "$arg2" == "wayland" ]; then
        sed -i 's/WaylandEnable=false/WaylandEnable=true/g' /etc/gdm/custom.conf
        echo "set Wayland session"
        reboot
    elif [ "$arg2" == "x11" ]; then
        sed -i 's/WaylandEnable=true/WaylandEnable=false/g' /etc/gdm/custom.conf
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

    if [ "$arg3" == "--chrome" ]; then
        command="google-chrome -kiosk \"$arg2\" --ignore-certificate-errors --password-store=basic --no-first-run --disable-first-run-ui"
        browser="chrome"
    elif [ "$arg3" == "--chromium" ]; then
        command="chromium-browser -kiosk \"$arg2\" --ignore-certificate-errors --password-store=basic --no-first-run --disable-first-run-ui"
        browser="chromium-browser"
    else
        command="firefox -kiosk \"$arg2\""
        browser="firefox"
    fi

    cat > /home/kiosk/.local/bin/gnome-kiosk-script << CONFIG
#!/bin/sh
$command
sleep 1.0
exec "\$0" "\$@"
CONFIG
    chmod +x /home/kiosk/.local/bin/gnome-kiosk-script
    echo "Set kiosk: $arg2"
    killall $browser &> /dev/null
}

main () {
    case "$arg1" in
        "enable" | "on" )
                sed -i 's/AutomaticLoginEnable=False/AutomaticLoginEnable=True/g' /etc/gdm/custom.conf
                echo "Kiosk enable"
                reboot
        ;;
        "disable" | "off" )
                sed -i 's/AutomaticLoginEnable=True/AutomaticLoginEnable=False/g' /etc/gdm/custom.conf
                echo "Kiosk disable"
                reboot
        ;;
        "set" )
                set_link
        ;;
        "session" )
                session
        ;;
        "help" | "h" | "" | "--h" | "--help")
                help
        ;;
        *)
            echo "invalid parameter"
            exit 1
        ;;
    esac
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
