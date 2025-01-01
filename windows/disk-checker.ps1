# Script : disk-checker.ps1
# Description : Récupère les informations détaillées sur les disques pour évaluation de PCs d'occasion
# Usage : powershell -File disk-checker.ps1
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

Write-Output "----------------------------------"
Write-Output "-- INFORMATIONS SUR LES DISQUES --"

# Vérifier si le script est exécuté en tant qu'administrateur
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Output "/!\ Il est recommandé d'exécuter ce script en tant qu'administrateur pour obtenir toutes les informations."
}

# Récupérer les informations des disques physiques
$physicalDisks = Get-PhysicalDisk

foreach ($disk in $physicalDisks) {
    # Récupérer les détails du disque
    $diskDetails = Get-Disk | Where-Object { $_.Number -eq $disk.DeviceId }

    Write-Output "Disque $($disk.DeviceId)"
    Write-Output "--> Model : $($disk.Model)"
    Write-Output "--> Fabricant : $($disk.Manufacturer)"
    Write-Output "--> Numéro de série : $($disk.SerialNumber)"
    Write-Output "--> Type : $($disk.MediaType)"
    Write-Output "--> Interface : $($disk.BusType)"
    Write-Output "--> Partitions : $($diskDetails.NumberOfPartitions)"
    Write-Output "--> Size : $($disk.Size) o ($([math]::Round($disk.Size / 1GB, 2)) Go)"
    Write-Output "--> État de santé : $($disk.HealthStatus)"
    Write-Output "--> État opérationnel : $($disk.OperationalStatus)"
    Write-Output "--> Firmware : $($disk.FirmwareVersion)"
}
