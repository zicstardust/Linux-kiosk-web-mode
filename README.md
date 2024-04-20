# Linux kiosk web mode

## Requirements
- Operation System: RHEL 9.x like (RHEL, OL, Rocky, etc) newly installed
- Root or sudo user configured and with ssh access available
- Desktop environment: GNOME
- Browser: Firefox

## Install

#### Default: DNF auto update enable
```bash
curl https://raw.githubusercontent.com/zicstardust/Linux-kiosk-web-mode/main/install.sh | sudo bash
```
#### Alternative: Disable dnf auto update
```bash
export EnableAutoUpdate="False"
curl https://raw.githubusercontent.com/zicstardust/Linux-kiosk-web-mode/main/install.sh | sudo bash
```

## Use

### Configure
```bash
sudo kiosk-config "<YOUR LINK HTTP/HTTPS HERE>"
```

### Enable
```bash
sudo kiosk-config enable
```

### Disable
```bash
sudo kiosk-config disable
```