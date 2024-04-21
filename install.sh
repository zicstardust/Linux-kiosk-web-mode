#!/usr/bin/bash

#Check root
is_root=$(whoami)
if [ ! $is_root == "root" ]; then
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

#Configura sessao gnome-kiosk para usuario kiosk
cat > /var/lib/AccountsService/users/kiosk << EOF
[User]
Session=gnome-kiosk-script
SystemAccount=false
EOF

#Config GDM
cat > /etc/gdm/custom.conf << EOF
# GDM configuration storage
 
[daemon]
# Uncomment the line below to force the login screen to use Xorg
#WaylandEnable=false
AutomaticLoginEnable=True
AutomaticLogin=kiosk
 
[security]
 
[xdmcp]
 
[chooser]
 
[debug]
# Uncomment the line below to turn on debugging
#Enable=true
EOF

# Download and install kiosk-config
curl https://raw.githubusercontent.com/zicstardust/Linux-kiosk-web-mode/main/kiosk-config.sh > /usr/bin/kiosk-config
chmod +x /usr/bin/kiosk-config

# Permissions kiosk home folder
mkdir -p /home/kiosk/.local/bin /home/kiosk/.config
chown -R kiosk:kiosk /home/kiosk

# Initial config
/usr/bin/kiosk-config set "gitlab.gnome.org/GNOME/gnome-kiosk/-/blob/main/README.md?ref_type=heads#user-content-gnome-kiosk"
