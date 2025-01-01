# Script : run-tests.ps1
# Description :
#   - Affiche le système d'exploitation et sa version.
#   - Lance une série de scripts PowerShell situés dans le même dossier, les uns après les autres.
#   - Annonce la fin des tests.
#
# Usage :
#   .\run-tests.ps1

# Fonction pour afficher les informations du système d'exploitation
function Get-OSInfo {
    try {
        $os = Get-CimInstance -ClassName Win32_OperatingSystem
        if ($os) {
            $osName = $os.Caption
            $osVersion = $os.Version
            $osBuildNumber = $os.BuildNumber
            Write-Host "Système d'exploitation : $osName"
            Write-Host "Version OS            : $osVersion"
            Write-Host "Numéro de build OS    : $osBuildNumber"
        } else {
            Write-Host "Impossible de récupérer les informations du système d'exploitation." -ForegroundColor Yellow
        }
    } catch {
        Write-Host "Erreur lors de la récupération des informations OS : $_" -ForegroundColor Red
    }
}

# Fonction pour exécuter un script PowerShell
function Execute-Script {
    param (
        [string]$ScriptPath
    )

    if (Test-Path $ScriptPath) {
        try {
            # Exécuter le script et attendre sa complétion
            & $ScriptPath
        } catch {
            Write-Host "Erreur lors de l'exécution du script $ScriptPath : $_" -ForegroundColor Red
        }
    } else {
        Write-Host "Script non trouvé : $ScriptPath" -ForegroundColor Yellow
    }
}

# 1. Afficher les informations du système d'exploitation
Write-Output "----------------------------------------"
Write-Output "-- INFORMATIONS DU SYSTÈME D'EXPLOITATION --"

Get-OSInfo

# 2. Définir le chemin du dossier contenant les scripts
$scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Definition

# 3. Définir la liste des scripts à exécuter dans l'ordre souhaité
$scriptsToRun = @(
    "pc-checker.ps1",
    "cpu-checker.ps1",
    "disk-checker.ps1",
    "ram-checker.ps1",
    "periph-checker.ps1",
    "batt-checker.ps1",
    "batt-perf-checker.ps1"
)

# 4. Exécuter chaque script séquentiellement
foreach ($script in $scriptsToRun) {
    $scriptPath = Join-Path -Path $scriptDirectory -ChildPath $script
    Execute-Script -ScriptPath $scriptPath
}

# 5. Annoncer la fin des tests
Write-Output "`n--------------------------------"
Write-Output "-- FIN DES TESTS DE PERFORMANCE --"

