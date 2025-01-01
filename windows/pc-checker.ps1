# Script : pc-checker.ps1
# Description : Récupère la marque, le modèle et le numéro de série du PC sous Windows
# Exemple d’exécution :
#   powershell -File pc-checker.ps1
# -----------------------------
# -- INFORMATIONS SUR L'APPAREIL --
# Marque : LENOVO
# Modèle : ThinkPad T14 Gen 2
# Numéro de série : ABC123XYZ
# -----------------------------

# Définir l'encodage de sortie à UTF-8 pour gérer les caractères spéciaux
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Output "---------------------------------"
Write-Output "-- INFORMATIONS SUR L'APPAREIL --"

# Récupération de la marque et du modèle via Win32_ComputerSystem
try {
    $computerSystem = Get-CimInstance -ClassName Win32_ComputerSystem
    if ($computerSystem) {
        $marque = $computerSystem.Manufacturer
        $modele = $computerSystem.Model
        Write-Output "Marque : $marque"
        Write-Output "Modèle : $modele"
    } else {
        Write-Output "Marque : Non disponible"
        Write-Output "Modèle : Non disponible"
    }
} catch {
    Write-Output "Marque : Erreur lors de la récupération"
    Write-Output "Modèle : Erreur lors de la récupération"
}

# Récupération du numéro de série via Win32_BIOS
try {
    $bios = Get-CimInstance -ClassName Win32_BIOS
    if ($bios) {
        $serial_number = $bios.SerialNumber
        Write-Output "Numéro de série : $serial_number"
    } else {
        Write-Output "Numéro de série : Non disponible"
    }
} catch {
    Write-Output "Numéro de série : Erreur lors de la récupération"
}

