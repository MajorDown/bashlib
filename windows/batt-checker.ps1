# Script : battery-checker.ps1
# Description : Affiche les informations détaillées sur la batterie sous Windows
# Usage : .\battery-checker.ps1

Write-Output "----------------------------------"
Write-Output "-- INFORMATIONS SUR LA BATTERIE --"

try {
    # Récupérer les informations de la batterie
    $battery = Get-WmiObject -Class Win32_Battery

    if ($battery) {
        # État de la batterie
        $status = switch ($battery.BatteryStatus) {
            1 { 'Décharge' }
            2 { 'En charge' }
            3 { 'Complètement chargée' }
            default { 'Inconnu' }
        }
        Write-Host "État : $status"

        # Pourcentage de charge restante
        $percentage = $battery.EstimatedChargeRemaining
        Write-Host "Pourcentage de charge : $percentage %"

        # Capacité actuelle et capacité totale théorique
        try {
            # Récupérer la capacité actuelle en mWh
            $batteryStatus = Get-WmiObject -Namespace 'root\WMI' -Class BatteryStatus
            $currentCapacity = $batteryStatus.RemainingCapacity

            if ($currentCapacity) {
                Write-Host "Capacité actuelle : $currentCapacity mWh"
            } else {
                Write-Host "Capacité actuelle : Non disponible"
            }

            # Calculer la capacité totale théorique
            if ($currentCapacity -gt 0 -and $percentage -gt 0) {
                $totalCapacity = [math]::Round(($currentCapacity / $percentage) * 100, 0)
                Write-Host "Capacité totale théorique : $totalCapacity mWh"
            } else {
                Write-Host "Capacité totale théorique : Non disponible"
            }
        } catch {
            Write-Host "Capacité actuelle : Non disponible"
            Write-Host "Capacité totale théorique : Non disponible"
        }

    } else {
        Write-Host "Aucune batterie détectée"
    }
} catch {
    Write-Host "Erreur lors de la récupération des informations sur la batterie : $_"
}

