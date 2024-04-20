#!/bin/bash
####################################################################################################################################
ssh_public_key="$1"
####################################################################################################################################

##Check root
is_root=$(whoami)
if [ ! $is_root == "root" ]; then
    echo "por favor, executar como root"
    exit 2
fi

#Enable automatic updates
dnf -y install dnf-automatic
systemctl daemon-reload
systemctl enable --now dnf-automatic-install.timer

##Insert ssh public key in sudo user
mkdir -p /home/kiosk/.ssh
cat > /home/kiosk/.ssh/authorized_keys << EOF
$ssh_public_key
EOF
chown -R kiosk:kiosk /home/kiosk/.ssh

##create kiosk user
useradd -m kiosk
passwd -d kiosk
 
##install gnome-kiosk session
dnf -y install gnome-kiosk-script-session


#Configura sessao gnome-kiosk para usuario kiosk
cat > /var/lib/AccountsService/users/kiosk << EOF
[User]
Session=gnome-kiosk-script
SystemAccount=false
EOF

##Config GDM
cat > /etc/gdm/custom.conf << EOF
# GDM configuration storage
 
[daemon]
# Uncomment the line below to force the login screen to use Xorg
#WaylandEnable=false
AutomaticLoginEnable=False
AutomaticLogin=kiosk
 
[security]
 
[xdmcp]
 
[chooser]
 
[debug]
# Uncomment the line below to turn on debugging
#Enable=true
EOF

## download and install kiosk-config
mkdir -p /home/kiosk/.local/bin /home/kiosk/.config
curl https://raw.githubusercontent.com/zicstardust/Linux-kiosk-web-mode/main/kiosk-config.sh > ./kiosk-config.sh
mv ./kiosk-config.sh /home/kiosk/.local/bin/kiosk-config
chmod +x /home/kiosk/.local/bin/kiosk-config
