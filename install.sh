#!/usr/bin/env bash

#Check root
if [ "$(whoami)" != "root" ]; then
    echo "Please, run as root"
    exit 2
fi

#Enable automatic updates
if [ ! "$EnableAutoUpdate" == "False" ]; then
    dnf -y install dnf-automatic
    systemctl daemon-reload
    systemctl enable --now dnf-automatic-install.timer
fi

#create kiosk user
useradd -m kiosk
passwd -d kiosk

#install gnome-kiosk session
dnf -y install gnome-kiosk-script-session


rhel_version=$(cat /etc/redhat-release)
if [[ $rhel_version == *" 10."* ]]; then
  gnome_kiosk_session="gnome-kiosk-script-wayland"
elif [[ $rhel_version == *" 9."* ]]; then
  gnome_kiosk_session="gnome-kiosk-script"
fi

#Configure session to kiosk user
mkdir -p /var/lib/AccountsService/users
cat > /var/lib/AccountsService/users/kiosk << EOF
[User]
Session=${gnome_kiosk_session}
SystemAccount=false
EOF

#Config GDM
mkdir -p /etc/gdm
cat > /etc/gdm/custom.conf << EOF
[daemon]
AutomaticLoginEnable=True
AutomaticLogin=kiosk
WaylandEnable=true
EOF

# Download and install kiosk-config
curl https://raw.githubusercontent.com/zicstardust/Linux-kiosk-web-mode/main/kiosk-config.sh > /usr/bin/kiosk-config
chmod +x /usr/bin/kiosk-config

# Permissions kiosk home folder
mkdir -p /home/kiosk/.local/bin /home/kiosk/.config
chown -R kiosk:kiosk /home/kiosk

# Initial config
/usr/bin/kiosk-config set "https://github.com/zicstardust/Linux-kiosk-web-mode/blob/main/README.md#use"
