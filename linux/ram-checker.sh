#!/bin/bash

# Script : ram-checker.sh
# Description : Récupère de manière robuste les informations détaillées sur la RAM sous linux
# exemple : 
# ram-checker.sh
# --------------------------
# --INFORMATIONS SUR LA RAM :
# RAM totale : 16 Go
# RAM utilisée : 6 Go
# RAM disponible : 10 Go
# BankLabel : BANK 0 (DIMM 0)
# Capacity : 8589934592 o
# MemoryType : 24 (DDR4)
# Speed : 2400 mhz
# TypeDetail : 128 (Synchronous)
# --------------------------

# Informations générales
echo "-----------------------------"
echo "-- INFORMATIONS SUR LA RAM --"

# RAM totale, utilisée et disponible
total_ram=$(free -m | awk '/^Mem:/{print $2}')
echo "RAM totale : $((total_ram / 1024)) Go"

used_ram=$(free -m | awk '/^Mem:/{print $3}')
echo "RAM utilisée : $((used_ram / 1024)) Go"

available_ram=$(free -m | awk '/^Mem:/{print $7}')
echo "RAM disponible : $((available_ram / 1024)) Go"

# Détails de la RAM
sudo dmidecode -t memory | grep -E "Bank Locator|Size|Type|Speed|Type Detail" | while read -r line; do
    case "$line" in
        *"Bank Locator"*) echo "BankLabel : ${line#*: }" ;;
        *"Size"*) echo "Capacity : ${line#*: }" ;;
        *"Type:"*) echo "MemoryType : ${line#*: }" ;;
        *"Speed"*) echo "Speed : ${line#*: }" ;;
        *"Type Detail"*) echo "TypeDetail : ${line#*: }" ;;
    esac
done
echo "-----------------------------"