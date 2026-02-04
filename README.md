# 🔥 Dotfiles - q4qd_ BSPWM Setup

![Parrot OS](https://img.shields.io/badge/Parrot%20OS-6.4-blue)
![BSPWM](https://img.shields.io/badge/WM-BSPWM-green)
![License](https://img.shields.io/badge/license-MIT-orange)

Configuración completa de BSPWM optimizada para pentesting y uso diario en Parrot Security OS.

## 📸 Screenshots

*(Agregá capturas de pantalla de tu setup aquí)*

## ✨ Características

- **Window Manager**: BSPWM (Binary Space Partitioning)
- **Terminal**: Kitty con soporte de emojis
- **Shell**: ZSH con Oh My Zsh + Powerlevel10k
- **Bar**: Polybar (tema: shapes)
- **Launcher**: Rofi
- **Compositor**: Picom
- **Capturas**: Flameshot
- **File Manager**: Ranger
- **Lock Screen**: i3lock-fancy

## 🖥️ Hardware Optimizado Para

- **CPU**: Intel Core i7 Q 820 @ 1.73GHz
- **RAM**: 31GB
- **GPU**: NVIDIA Quadro FX 880M (driver Nouveau)
- **Almacenamiento**: SSD

## ⚙️ Optimizaciones Incluidas

- ✅ CPU Governor en modo performance
- ✅ Swappiness configurado a 10
- ✅ SSD optimizado (noatime, nodiratime, TRIM)
- ✅ Servicios innecesarios deshabilitados (Bluetooth, ModemManager)
- ✅ Parámetros de Nouveau optimizados para NVIDIA
- ✅ Compositor deshabilitado para mejor rendimiento

## 🚀 Instalación Rápida

### Requisitos Previos

- Parrot Security OS 6.4 (o Debian/Ubuntu-based)
- Conexión a Internet
- Usuario con privilegios sudo

### Instalación

1. Clonar el repositorio
2. Ejecutar install.sh
3. Reiniciar el sistema
4. Seleccionar bspwm en el login

## ⌨️ Atajos de Teclado Principales

- Super + Enter: Abrir Kitty
- Super + D: Rofi launcher
- Super + Shift + O: Abrir Obsidian
- Super + Shift + R: Reiniciar BSPWM
- Super + W: Cerrar ventana
- Print Screen: Captura de pantalla

Ver todos los atajos en: ~/.config/sxhkd/sxhkdrc

## 📁 Estructura del Repositorio

- config/: Configuraciones de BSPWM, Polybar, Kitty, etc.
- scripts/: Scripts personalizados
- docs/: Documentación adicional
- backups/: Backups de configuraciones
- install.sh: Script de instalación automática

## 🤝 Créditos

- Setup base: r1vs3c/auto-bspwm
- Tema Polybar: adi1090x/polybar-themes

## 📄 Licencia

MIT License - Usá, modificá y compartí libremente.

---

Hecho con ❤️ para la comunidad de pentesting
