#!/bin/bash

# Script : ram-checker.sh
# Description : Récupère de manière robuste les informations détaillées sur la RAM sous macOS
# exemple : 
# ram-checker.sh
# ----------------------------
# --INFORMATIONS SUR LA RAM --
# RAM totale : 16 Go
# RAM utilisée : 6 Go
# RAM disponible : 10 Go
# BankLabel : BANK 0 (DIMM 0)
# Capacity : 8589934592 o
# MemoryType : 24 (DDR4)
# Speed : 2400 mhz
# TypeDetail : 128 (Synchronous)
# ----------------------------

# Informations générales
echo "-----------------------------"
echo "-- INFORMATIONS SUR LA RAM --"

# RAM totale, utilisée et disponible
total_ram=$(sysctl -n hw.memsize)
echo "RAM totale : $((total_ram / 1024 / 1024 / 1024)) Go"

used_ram=$(vm_stat | grep "Pages active" | awk '{print $3}' | sed 's/\.//')
echo "RAM utilisée : $((used_ram * 4096 / 1024 / 1024 / 1024)) Go"

free_ram=$(vm_stat | grep "Pages free" | awk '{print $3}' | sed 's/\.//')
echo "RAM disponible : $((free_ram * 4096 / 1024 / 1024 / 1024)) Go"

# Détails de la RAM
sudo system_profiler SPMemoryDataType | grep -E "Bank Locator|Size|Type|Speed" | while read -r line; do
    case "$line" in
        *"Bank Locator"*) echo "BankLabel : ${line#*: }" ;;
        *"Size"*) echo "Capacity : ${line#*: }" ;;
        *"Type:"*) echo "MemoryType : ${line#*: }" ;;
        *"Speed"*) echo "Speed : ${line#*: }" ;;
    esac
done
echo "-----------------------------"