#!/bin/bash

# Detectar interfaz conectada
WIFI_INTERFACE="wlp3s0"
ETH_INTERFACE="enp0s25"

# Verificar si Wi-Fi está conectado
WIFI_STATUS=$(cat /sys/class/net/$WIFI_INTERFACE/operstate 2>/dev/null)

# Verificar si Ethernet está conectado  
ETH_STATUS=$(cat /sys/class/net/$ETH_INTERFACE/operstate 2>/dev/null)

if [ "$WIFI_STATUS" = "up" ]; then
    # Wi-Fi conectado
    ESSID=$(iwgetid -r 2>/dev/null || echo "Wi-Fi")
    IP=$(ip addr show $WIFI_INTERFACE | grep "inet " | awk '{print $2}' | cut -d/ -f1)
    echo "說 $ESSID - $IP"
elif [ "$ETH_STATUS" = "up" ]; then
    # Ethernet conectado
    IP=$(ip addr show $ETH_INTERFACE | grep "inet " | awk '{print $2}' | cut -d/ -f1)
    echo "󰈀 Ethernet - $IP"
else
    # Sin conexión
    echo "ﲁ Offline"
fi
