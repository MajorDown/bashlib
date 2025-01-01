<#
.SYNOPSIS
    Ajoute une nouvelle correspondance PartNumber - MemoryType dans ram-data.json.

.DESCRIPTION
    Ce script permet d’ajouter une nouvelle entrée ou de mettre à jour une entrée existante dans le fichier ram-data.json.
    Il accepte des paramètres pour le PartNumber et le MemoryType, valide les entrées, et sauvegarde les modifications dans le fichier JSON.

.PARAMETER pn
    Le PartNumber de la RAM à ajouter ou mettre à jour.

.PARAMETER ddr
    Le type de mémoire DDR (DDR2, DDR3, DDR4, DDR5, DDR6, Unknown).

.EXAMPLE
    powershell -File new-ram-pn.ps1 -pn "XYZ123PARTNUM" -ddr "DDR3"

    Ajoute une nouvelle correspondance avec PartNumber "XYZ123PARTNUM" et MemoryType "DDR3".

.NOTES
    Assurez-vous que le script new-ram-pn.ps1 et ram-data.json se trouvent dans le même répertoire.
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true, HelpMessage = "Entrez le PartNumber de la RAM.")]
    [ValidateNotNullOrEmpty()]
    [string]$pn,

    [Parameter(Mandatory = $true, HelpMessage = "Entrez le MemoryType (DDR2, DDR3, DDR4, DDR5, DDR6, Unknown).")]
    [ValidateSet("DDR2", "DDR3", "DDR4", "DDR5", "DDR6", "Unknown", IgnoreCase = $true)]
    [string]$ddr
)

# Définir le chemin du fichier JSON
$scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Definition
$mappingFilePath = Join-Path -Path $scriptDirectory -ChildPath "ram-data.json"

# Fonction pour charger le fichier JSON en Hashtable
function Load-RamData {
    param (
        [string]$Path
    )

    if (Test-Path $Path) {
        try {
            $jsonContent = Get-Content -Path $Path -Raw | ConvertFrom-Json
            # Convertir l'objet JSON en Hashtable
            $hashtable = @{}
            foreach ($property in $jsonContent.PSObject.Properties) {
                $hashtable[$property.Name] = $property.Value
            }
            return $hashtable
        } catch {
            Write-Error "Erreur lors du chargement du fichier JSON : $_"
            exit 1
        }
    } else {
        # Si le fichier n'existe pas, créer une nouvelle Hashtable
        Write-Host "Fichier 'ram-data.json' introuvable. Création d'un nouveau fichier." -ForegroundColor Yellow
        return @{}
    }
}

# Fonction pour sauvegarder la Hashtable dans le fichier JSON
function Save-RamData {
    param (
        [hashtable]$Data,
        [string]$Path
    )

    try {
        # Convertir la Hashtable en objet JSON formaté
        $jsonObject = @{}
        foreach ($key in $Data.Keys) {
            $jsonObject[$key] = $Data[$key]
        }
        $jsonContent = $jsonObject | ConvertTo-Json -Depth 10 | Out-String
        Set-Content -Path $Path -Value $jsonContent -Encoding UTF8
    } catch {
        Write-Error "Erreur lors de la sauvegarde du fichier JSON : $_"
        exit 1
    }
}

# Charger les données existantes
$ramData = Load-RamData -Path $mappingFilePath

# Vérifier si le PartNumber existe déjà
if ($ramData.ContainsKey($pn)) {
    Write-Warning "Le PartNumber '$pn' existe déjà avec MemoryType '$($ramData[$pn])'."
    $confirm = Read-Host "Voulez-vous écraser cette entrée ? (O/N)"
    if ($confirm -ne 'O' -and $confirm -ne 'o') {
        Write-Host "Ajout annulé." -ForegroundColor Green
        exit 0
    } else {
        Write-Host "Écrasement de l'entrée existante." -ForegroundColor Yellow
    }
}

# Ajouter ou mettre à jour la correspondance
$ramData[$pn] = $ddr.ToUpper()

# Sauvegarder les données mises à jour
Save-RamData -Data $ramData -Path $mappingFilePath

Write-Host "Le PartNumber '$pn' avec MemoryType '$ddr' a été ajouté avec succès dans 'ram-data.json'." -ForegroundColor Green
