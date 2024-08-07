# Linux kiosk web mode

## Compatible distros:
- RHEL 9.X like (RHEL, Oracle Linux, Rocky, AlmaLinux, etc)
- CentOS Stream 9

## Requirements
- Operation System newly installed
- Root or sudo user configured and ssh access available
- Desktop environment: GNOME
- Browser: Firefox or Google Chrome

## Install

```bash
curl https://raw.githubusercontent.com/zicstardust/Linux-kiosk-web-mode/main/install.sh | sudo bash
```
#### Alternative: Disable dnf auto update
```bash
export EnableAutoUpdate="False"
curl https://raw.githubusercontent.com/zicstardust/Linux-kiosk-web-mode/main/install.sh | sudo bash
```

## Use

### Configure:
```bash
sudo kiosk-config set "<LINK HTTP/HTTPS HERE>"
```

### Configure with Google Chrome:
```bash
sudo kiosk-config set "<LINK HTTP/HTTPS HERE>" --chrome
```

### Enable/Disable kiosk mode:

#### Enable (Default):
```bash
sudo kiosk-config enable
```

#### Disable:
```bash
sudo kiosk-config disable
```

### Change Wayland or X11

#### Use Wayland (Default):
```bash
sudo kiosk-config session wayland
```

#### Use X11:
```bash
sudo kiosk-config session x11
```
