# Script : periph-checker.ps1
# Description : Affiche une checklist des périphériques connectés sous Windows.
# Usage : powershell -File periph-checker.ps1
# ---------------------------------
# -- CHECKLIST DES PÉRIPHÉRIQUES --
# Clavier : Présent
# Trackpad : Présent
# Webcam : Présente
# Écran principal : Présent
# Son : Fonctionnel
# ---------------------------------

Write-Output "---------------------------------"
Write-Output "-- CHECKLIST DES PÉRIPHÉRIQUES --"

# Clavier
$keyboard = Get-CimInstance -ClassName Win32_Keyboard
if ($keyboard) {
    Write-Output "Clavier : Présent"
} else {
    Write-Output "Clavier : Absent"
}

# Trackpad (ou souris)
$mouse = Get-CimInstance -ClassName Win32_PointingDevice
if ($mouse) {
    Write-Output "Trackpad : Présent"
} else {
    Write-Output "Trackpad : Absent"
}

# Webcam
try {
    $webcam = Get-CimInstance -Namespace root\cimv2 -ClassName Win32_PnPEntity | Where-Object { $_.Name -match 'Camera|Webcam' }
    if ($webcam) {
        Write-Output "Webcam : Présente"
    } else {
        Write-Output "Webcam : Absente"
    }
} catch {
    Write-Output "Webcam : Erreur d'analyse"
}

# Écran principal
$monitor = Get-CimInstance -Namespace root\wmi -ClassName WmiMonitorBasicDisplayParams
if ($monitor) {
    Write-Output "Écran principal : Présent"
} else {
    Write-Output "Écran principal : Absent"
}

# Son (haut-parleurs ou casque)
$audio = Get-CimInstance -ClassName Win32_SoundDevice
if ($audio) {
    Write-Output "Son : Fonctionnel"
} else {
    Write-Output "Son : Aucun périphérique audio détecté"
}