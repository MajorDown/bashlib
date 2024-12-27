#!/bin/bash

# Script : disk-checker.sh
# Description : Récupère les informations détaillées sur les disques pour évaluation de PCs sous Linux
# Usage : bash disk-checker.sh
# ----------------------------------
# -- INFORMATIONS SUR LES DISQUES --
# Disque sda
# Model : Samsung SSD 970 EVO 500GB
# Fabricant : Samsung
# Numéro de série : S4EWNF0M101234
# Type : SSD
# Interface : NVMe
# Partitions : 3
# Size : 500107862016 o (465.76 Go)
# État de santé : Healthy
# État opérationnel : OK
# Firmware : 2B2QEXE7
# ----------------------------------

echo "----------------------------------"
echo "-- INFORMATIONS SUR LES DISQUES --"

# Obtenir la liste des disques (en excluant les partitions)
for disk in $(lsblk -d -o NAME | grep -v NAME); do
    # Informations générales
    echo "Disque ${disk#"/dev/"}"  
    model=$(smartctl -i /dev/$disk | grep "Model" | cut -d: -f2 | tr -d ' ')
    echo "Model : $model"

    # Fabricant
    vendor=$(smartctl -i /dev/$disk | grep "Vendor" | cut -d: -f2 | tr -d ' ')
    echo "Fabricant : $vendor"

    # Numéro de série    
    serial=$(smartctl -i /dev/$disk | grep "Serial" | cut -d: -f2 | tr -d ' ')
    echo "Numéro de série : $serial"

    # Type 
    rotation=$(smartctl -i /dev/$disk | grep "Rotation Rate" | cut -d: -f2)
    if [[ $rotation == *"Solid State"* ]]; then
        type="SSD"
    else
        type="HDD"
    fi
    echo "Type : $type"

    # Interface   
    interface=$(smartctl -i /dev/$disk | grep "Transport protocol" | cut -d: -f2 | tr -d ' ')
    echo "Interface : $interface"

    # Partitions   
    partitions=$(lsblk -l /dev/$disk | grep -v $disk | wc -l)
    echo "Partitions : $partitions"
    
    # Taille
    size_bytes=$(lsblk -b -d -o SIZE /dev/$disk | grep -v SIZE)
    size_gb=$(echo "scale=2; $size_bytes/1024/1024/1024" | bc)
    echo "Size : $size_bytes o ($size_gb Go)"
    
    # État de santé
    health=$(smartctl -H /dev/$disk | grep "test result" | cut -d: -f2 | tr -d ' ')
    if [[ "$health" == "PASSED" ]]; then
        health_status="Healthy"
        operational_status="OK"
    else
        health_status="Unhealthy"
        operational_status="Error"
    fi
    echo "État de santé : $health_status"
    echo "État opérationnel : $operational_status"
    
    # Firmware
    firmware=$(smartctl -i /dev/$disk | grep "Firmware" | cut -d: -f2 | tr -d ' ')
    echo "Firmware : $firmware"
    
    echo "----------------------------------"
done