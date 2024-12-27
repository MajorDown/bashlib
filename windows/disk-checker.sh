#!/bin/bash

# Script : disk-checker.sh
# Description : Récupère les informations détaillées sur les disques pour évaluation de PCs d'occasion
# Usage : bash disk-checker.sh
# ----------------------------------
# -- INFORMATIONS SUR LES DISQUES --
# Disque 0
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
# Heures de fonctionnement : 1234 heures
# Température : 45 °C
# Erreurs de lecture : 0
# Erreurs d'écriture : 0
# ----------------------------------

echo "----------------------------------"
echo "-- INFORMATIONS SUR LES DISQUES --"

powershell.exe -Command "
# Exécuter en tant qu'administrateur si possible
\$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

Get-PhysicalDisk | ForEach-Object {
    \$disk = \$_
    \$details = Get-Disk | Where-Object { \$_.Number -eq \$disk.DeviceId }
    
    Write-Host \"Disque \$(\$disk.DeviceId)\"
    Write-Host \"Model : \$(\$disk.Model)\"
    Write-Host \"Fabricant : \$(\$disk.Manufacturer)\"
    Write-Host \"Numéro de série : \$(\$disk.SerialNumber)\"
    Write-Host \"Type : \$(\$disk.MediaType)\"
    Write-Host \"Interface : \$(\$disk.BusType)\"
    Write-Host \"Partitions : \$(\$details.NumberOfPartitions)\"
    Write-Host \"Size : \$(\$disk.Size) o (\$([math]::Round(\$disk.Size/1GB, 2)) Go)\"
    Write-Host \"État de santé : \$(\$disk.HealthStatus)\"
    Write-Host \"État opérationnel : \$(\$disk.OperationalStatus)\"
    Write-Host \"Firmware : \$(\$disk.FirmwareVersion)\"
}"