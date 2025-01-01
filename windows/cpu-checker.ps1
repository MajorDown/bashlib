# Script : cpu-checker.ps1
# Description : Récupère des informations détaillées sur le processeur pour évaluation
# Usage : powershell -File cpu-checker.ps1
# -------------------------------
# Exemple de sortie :
# Nom : Intel(R) Core(TM) i7-7500U CPU @ 2.70GHz
# Cœurs physiques : 2
# Cœurs logiques : 4
# Fréquence maximale : 2.90 GHz
# Utilisation : 12 %

Write-Output "-----------------------------"
Write-Output "-- INFORMATIONS SUR LE CPU --"

# Informations générales du CPU
$cpu = Get-CimInstance -ClassName Win32_Processor

# Récupération du nom du CPU
$nomCpu = $cpu.Name
Write-Output "Nom : $nomCpu"

# Récupération du nombre de cœurs physiques
$coresPhysiques = $cpu.NumberOfCores
Write-Output "Cœurs physiques : $coresPhysiques"

# Récupération du nombre de cœurs logiques
$coresLogiques = $cpu.NumberOfLogicalProcessors
Write-Output "Cœurs logiques : $coresLogiques"

# Récupération de la fréquence maximale en GHz
$frequenceMax = [math]::Round($cpu.MaxClockSpeed / 1000, 2)
Write-Output "Fréquence maximale : $frequenceMax GHz"

# Récupération de l'utilisation du CPU en utilisant LoadPercentage
try {
    # Récupérer tous les processeurs et calculer la moyenne de LoadPercentage
    $cpuLoadObjects = Get-CimInstance -ClassName Win32_Processor
    if ($cpuLoadObjects) {
        $averageLoad = ($cpuLoadObjects | Measure-Object -Property LoadPercentage -Average).Average
        # Arrondir à zéro décimale
        $cpuLoad = [math]::Round($averageLoad, 0)
        Write-Output "Utilisation : $cpuLoad %"
    } else {
        Write-Output "Utilisation : Non disponible"
    }
} catch {
    Write-Output "Utilisation : Non disponible"
}

