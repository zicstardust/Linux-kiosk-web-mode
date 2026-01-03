#!/usr/bin/env bash
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

kiosk-config --uninstall
    Uninstall kiosk-config
HELP
    cat /tmp/kiosk-config
    rm -f /tmp/kiosk-config
}

set_link(){
    local link=$1
    local use_browser=$2
    if [ -z "$link" ]; then
        echo "parameter missing"
        exit 1
    fi

    if [ "$use_browser" == "--chrome" ]; then
        command="chrome -kiosk \"$link\" --ignore-certificate-errors --password-store=basic --no-first-run --disable-first-run-ui"
    elif [ "$use_browser" == "--chromium" ]; then
        command="chromium-browser -kiosk \"$link\" --ignore-certificate-errors --password-store=basic --no-first-run --disable-first-run-ui"
    else
        command="firefox -kiosk \"$link\""
    fi

    cat > /home/kiosk/.local/bin/gnome-kiosk-script << CONFIG
#!/bin/sh
$command
sleep 1.0
exec "\$0" "\$@"
CONFIG
    chmod +x /home/kiosk/.local/bin/gnome-kiosk-script
    echo "Set kiosk: $link"
    killall --user kiosk &> /dev/null
}


uninstall (){
    rm -f /usr/bin/kiosk-config
    userdel -r kiosk
    rm -f /var/lib/AccountsService/users/kiosk
    rm -f /etc/gdm/custom.conf
    dnf remove -y gnome-kiosk dnf-automatic
    rm -Rf /home/kiosk
    echo "kiosk-config uninstalled, please reboot your system"
}

main () {
    case "$arg1" in
        "enable" | "on" )
                sed -i 's/AutomaticLoginEnable=False/AutomaticLoginEnable=True/g' /etc/gdm/custom.conf
                echo "Kiosk enable, please reboot your system"
        ;;
        "disable" | "off" )
                sed -i 's/AutomaticLoginEnable=True/AutomaticLoginEnable=False/g' /etc/gdm/custom.conf
                echo "Kiosk disable, please reboot your system"
        ;;
        "set" )
                set_link $arg2 $arg3
        ;;
        "--uninstall" )
                uninstall
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
if [ "$(whoami)" != "root" ]; then
    echo "Please, run as root"
    exit 1
else
    main
    exit 0
fi
