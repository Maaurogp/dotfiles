#!/bin/bash

# Esperar a que X esté completamente listo
sleep 3

# Primero desconectar todo y reconectar en orden correcto
xrandr --output LVDS-1 --off
xrandr --output VGA-1 --off
xrandr --output DP-2 --off

sleep 1

# Encender DP-2 primero (izquierda)
xrandr --output DP-2 --mode 1920x1080 --pos 0x0

sleep 1

# Encender VGA-1 después (derecha)
xrandr --output VGA-1 --mode 1920x1080 --pos 1920x0

sleep 1

# Establecer primario
xrandr --output DP-2 --primary

# Limpiar configuración de bspwm
bspc wm -r

sleep 2

# Configurar desktops en orden correcto
bspc monitor DP-2 -d I II III IV V
bspc monitor VGA-1 -d VI VII VIII IX X
