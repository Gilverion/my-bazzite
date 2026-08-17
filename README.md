# My Custom Bazzite Image base on the latest bazzite-nvidia image

A tailored, immutable Linux system based on [Bazzite](https://bazzite.gg/) and managed with [BlueBuild](https://blue-build.org/). 

This image extends the official Bazzite base image with personal system services, drivers, and optimizations—without requiring local `rpm-ostree` layered packages on the target machine.

## 🚀 Key Features & Customizations

* **Applications & Drivers:**
  * **Discord:** Official installation embedded directly into the system image.
  * **CoolerControl:** Comprehensive fan control suite including the background service (`coolercontrold.service`).
  * **ckb-next:** Driver software for Corsair peripherals along with its daemon (`ckb-next-daemon.service`).
* **System Cleanups:**
  * Removal of Waydroid
* **Security:**
  * Automated digital container signing via **Cosign**.

---

## 📦 Installation & Setup (Rebase)

To switch your system to this custom image, execute the following steps in your terminal:

### 1. Store the public Cosign key locally
Enable your system to cryptographically verify your GitHub image signature:

sudo mkdir -p /etc/pki/containers
sudo cp cosign.pub /etc/pki/containers/my-bazzite.pub

### 2. Rebase your system
Rebase to the signed registry entry:

rpm-ostree rebase ostree-image-signed:docker://ghcr.io/gilverion/my-bazzite:latest

Reboot your system once the rebase completes:

systemctl reboot

---

## 🔄 Updates

Once rebased, your system is linked directly to your GitHub Container Registry. You will receive daily updates—including upstream Bazzite and Linux kernel updates—via standard system updates:

---

## 🛠️ Repository Structure

* `.github/workflows/`: GitHub Actions workflows for building and signing the image automatically.
* `recipes/recipe.yml`: Main BlueBuild configuration recipe.
* `files/scripts/`: Custom bash scripts executed during the image build phase.
