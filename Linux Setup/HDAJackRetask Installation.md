# HDAJackRetask Installation Guide

**HDAJackRetask** is a utility from the `alsa-tools` package that allows you to remap audio jacks on systems using the ALSA sound system.

---

## 🐧 Ubuntu / Debian

Install `alsa-tools-gui`, which includes `hdajackretask`:

```bash
sudo apt update
sudo apt install alsa-tools-gui
````

---

## 🐮 Fedora

Install the `alsa-tools-gui` package using `dnf`:

```bash
sudo dnf install alsa-tools
```

---

## 🎯 Arch Linux / Manjaro / EndeavourOS

Install `alsa-tools` from the official repositories:

```bash
sudo pacman -S alsa-tools
```

---

## 🚀 Launching HDAJackRetask

Use the following command to start the application:

```bash
sudo hdajackretask
```

> ℹ️ It may require `sudo` to access hardware-level settings.

---

## 📚 Additional Notes

* Ensure ALSA is properly configured on your system.
* Some changes may require a reboot or reloading the ALSA modules.
