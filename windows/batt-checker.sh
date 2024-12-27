#!/bin/bash

# Script : battery-checker.sh
# Description : Affiche les informations détaillées sur la batterie sous Windows
# Usage : bash battery-checker.sh

echo "----------------------------------"
echo "-- INFORMATIONS SUR LA BATTERIE --"

powershell.exe -Command "
\$battery = Get-WmiObject -Class Win32_Battery
if (\$battery) {
    # État
    \$status = switch (\$battery.BatteryStatus) {
        1 { 'Décharge' }
        2 { 'En charge' }
        3 { 'Complètement chargée' }
        default { 'Inconnu' }
    }
    Write-Host \"État : \$(\$status)\"

    # Pourcentage de charge
    \$percentage = \$battery.EstimatedChargeRemaining
    Write-Host \"Pourcentage de charge : \$(\$percentage) %\"

    # Capacité actuelle
    try {
        \$currentCapacity = (Get-WmiObject -Namespace 'root\\WMI' -Class BatteryStatus).RemainingCapacity
        Write-Host \"Capacité actuelle : \$(if (\$currentCapacity) { \$currentCapacity } else { 'Non disponible' }) mWh\"

        # Calcul de la capacité totale théorique
        if (\$currentCapacity -gt 0 -and \$percentage -gt 0) {
            \$totalCapacity = [math]::Round((\$currentCapacity / \$percentage) * 100, 0)
            Write-Host \"Capacité totale théorique : \$(\$totalCapacity) mWh\"
        } else {
            Write-Host \"Capacité totale théorique : Non disponible\"
        }
    } catch {
        Write-Host \"Capacité actuelle : Non disponible\"
        Write-Host \"Capacité totale théorique : Non disponible\"
    }

} else {
    Write-Host \"Aucune batterie détectée\"
}
"
