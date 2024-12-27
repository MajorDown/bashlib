#!/bin/bash

# Script : cpu-checker.sh
# Description : Récupère des informations détaillées sur le processeur pour évaluation
# Usage : bash cpu-checker.sh
# -------------------------------
# Exemple de sortie :
# Nom : Intel(R) Core(TM) i7-7500U CPU @ 2.70GHz
# Cœurs physiques : 2
# Cœurs logiques : 4
# Fréquence maximale : 2.90 GHz
# Température : Non disponible
# Utilisation : 12 %
# -------------------------------

echo "-------------------------------"
echo "-- INFORMATIONS SUR LE CPU --"

powershell.exe -Command "
# Informations générales du CPU
\$cpu = Get-CimInstance -ClassName Win32_Processor

Write-Host \"Nom : \$(\$cpu.Name)\"
Write-Host \"Cœurs physiques : \$(\$cpu.NumberOfCores)\"
Write-Host \"Cœurs logiques : \$(\$cpu.NumberOfLogicalProcessors)\"
Write-Host \"Fréquence maximale : \$(\$cpu.MaxClockSpeed/1000) GHz\"

# Température du CPU
try {
    \$tempSensor = Get-WmiObject -Namespace root\WMI -Class MSAcpi_ThermalZoneTemperature -ErrorAction SilentlyContinue
    if (\$tempSensor) {
        \$temperature = (\$tempSensor.CurrentTemperature / 10) - 273.15
        Write-Host \"Température : \$(\$temperature) °C\"
    } else {
        Write-Host \"Température : Non disponible\"
    }
} catch {
    Write-Host \"Température : Non disponible\"
}

# Charge du CPU
try {
    \$cpuLoad = (Get-CimInstance -ClassName Win32_Processor).LoadPercentage
    Write-Host \"Utilisation : \$(\$cpuLoad) %\"
} catch {
    Write-Host \"Utilisation : Non disponible\"
}
"
