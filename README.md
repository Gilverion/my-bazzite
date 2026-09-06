# My Custom Bazzite Image

A tailored, immutable Linux system based on the latest **`bazzite-nvidia`** image and managed with [BlueBuild](https://blue-build.org/).

This image extends the official Bazzite base image with personal system services, drivers, custom fonts, and optimizations—without requiring local `rpm-ostree` layered packages on the target machine.

---

## 🚀 Key Features & Customizations

### Applications & Drivers
* **Discord:** Official installation embedded directly into the system image.
* **Faugus Launcher:** Pre-installed launcher for gaming and compatibility management.
* **CoolerControl:** Comprehensive fan control suite including the background service (`coolercontrold.service`).
* **ckb-next:** Driver software for Corsair peripherals along with its daemon (`ckb-next-daemon.service`).

### System Enhancements & Fonts
* **Microsoft Core & ClearType Fonts:** Full system-wide integration of MS fonts (including Calibri, Cambria, Arial, etc.) for flawless document compatibility in ONLYOFFICE and LibreOffice.

### System Cleanups
* **Waydroid Removal:** Stripped out Waydroid remnants to keep the system footprint clean.

### Security
* **Cosign Signed:** Automated digital container signing via Cosign for safe image deployments.

---

## 📦 Installation & Setup (Rebase)

### 1. Rebase your system
Rebase your running system to the signed registry entry:

rpm-ostree rebase ostree-image-signed:docker://ghcr.io/gilverion/my-bazzite:latest

### 2. Reboot your system

systemctl reboot
