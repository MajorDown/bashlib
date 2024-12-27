#!/bin/bash

# Script : periph-checker.sh
# Description : Affiche une checklist des périphériques connectés sous Windows.
# Usage : bash periph-checker.sh

echo "---------------------------------"
echo "-- CHECKLIST DES PÉRIPHÉRIQUES --"

powershell.exe -Command "
# Clavier
\$keyboard = Get-WmiObject -Class Win32_Keyboard
if (\$keyboard) {
    Write-Host 'Clavier : Présent'
} else {
    Write-Host 'Clavier : Absent'
}

# Trackpad (ou souris)
\$mouse = Get-WmiObject -Class Win32_PointingDevice
if (\$mouse) {
    Write-Host 'Trackpad : Présent'
} else {
    Write-Host 'Trackpad : Absent'
}

# Webcam
try {
    \$webcam = Get-WmiObject -Namespace root\\cimv2 -Class Win32_PnPEntity | Where-Object { \$_.Name -match 'Camera|Webcam' }
    if (\$webcam) {
        Write-Host 'Webcam : Présente'
    } else {
        Write-Host 'Webcam : Absente'
    }
} catch {
    Write-Host 'Webcam : Erreur d''analyse'
}

# Écran principal
\$monitor = Get-WmiObject -Namespace root\\wmi -Class WmiMonitorBasicDisplayParams
if (\$monitor) {
    Write-Host 'Écran principal : Présent'
} else {
    Write-Host 'Écran principal : Absent'
}

# Son (haut-parleurs ou casque)
\$audio = Get-WmiObject -Class Win32_SoundDevice
if (\$audio) {
    Write-Host 'Son : Fonctionnel'
} else {
    Write-Host 'Son : Aucun périphérique audio détecté'
}
"
