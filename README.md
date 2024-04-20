# Linux kiosk web mode

## Requirements
- Operation System: RHEL 9.x like (RHEL, OL, Rocky, etc)
- Desktop environment: GNOME
- Browser: Firefox

## Install

### Without SSH public KEY
```bash
curl https://raw.githubusercontent.com/zicstardust/Linux-kiosk-web-mode/main/install.sh | bash
```

### With SSH public KEY
```bash
ssh_public_key="YOUR PUBLIC KEY HERE"
curl https://raw.githubusercontent.com/zicstardust/Linux-kiosk-web-mode/main/install.sh | bash -s "$ssh_public_key"
```

## Use

### Configure
```bash
link="YOUR LINK HTTP/HTTPS HERE"
kiosk-config $link
```

### Enable
```bash
kiosk-config enable
```

### Disable
```bash
kiosk-config disable
```