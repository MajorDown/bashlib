# Script : ram-checker.ps1
# Description : Récupère de manière robuste les informations détaillées sur la RAM sous Windows
# Exemple d’exécution :
#   powershell -File ram-checker.ps1
# -----------------------------
# -- INFORMATIONS SUR LA RAM --
# RAM totale : 16 Go
# RAM utilisée : 6 Go
# RAM disponible : 10 Go
# BankLabel : BANK 0
# --> Capacity : 8589934592 o
# --> MemoryType : DDR4
# --> Speed : 2400 mhz
# --> Manufacturer : Samsung
# --> PartNumber : M378A1K43CB1-CRC
# BankLabel : BANK 2
# --> Capacity : 8589934592 o
# --> MemoryType : DDR4
# --> Speed : 2400 mhz
# --> Manufacturer : Samsung
# --> PartNumber : M378A1K43CB1-CRC

Write-Output "-----------------------------"
Write-Output "-- INFORMATIONS SUR LA RAM --"

# Chemin du fichier de correspondance
$mappingFilePath = Join-Path -Path (Split-Path -Parent $MyInvocation.MyCommand.Definition) -ChildPath "ram-data.json"

# Charger la table de correspondance des PartNumber aux MemoryType
if (Test-Path $mappingFilePath) {
    try {
        $mappingObject = Get-Content -Path $mappingFilePath -Raw | ConvertFrom-Json
        # Convertir l'objet JSON en hashtable
        $partNumberToMemoryType = @{}
        foreach ($property in $mappingObject.PSObject.Properties) {
            $partNumberToMemoryType[$property.Name] = $property.Value
        }
    } catch {
        Write-Warning "Impossible de charger le fichier de correspondance. Les MemoryType seront déterminés via WMI."
        $partNumberToMemoryType = @{}
    }
} else {
    Write-Warning "Fichier de correspondance 'ram-data.json' introuvable. Les MemoryType seront déterminés via WMI."
    $partNumberToMemoryType = @{}
}

# Fonction pour obtenir le MemoryType à partir du PartNumber
function Get-MemoryType($partNumber, $memoryTypeCode) {
    if ($partNumberToMemoryType.ContainsKey($partNumber)) {
        return $partNumberToMemoryType[$partNumber]
    } else {
        # Fallback to WMI MemoryType if PartNumber not in mappings
        $memoryTypeDesc = switch ($memoryTypeCode) {
            0  { "Unknown" }
            20 { "DDR3" }
            21 { "DDR3" }
            22 { "DDR2" }
            24 { "DDR4" }
            26 { "DDR5" }
            28 { "DDR6" }
            default { "Code inconnu ($memoryTypeCode)" }
        }
        return "$memoryTypeCode ($memoryTypeDesc)"
    }
}

# Récupération des informations sur la RAM totale, utilisée et disponible
try {
    # Récupérer la RAM totale en bytes
    $computerSystem = Get-CimInstance -ClassName Win32_ComputerSystem
    if ($computerSystem) {
        $totalMemoryBytes = $computerSystem.TotalPhysicalMemory
        # Convertir en Go (1 Go = 1,073,741,824 bytes)
        $totalMemoryGB = [math]::Round($totalMemoryBytes / 1073741824, 2)
    } else {
        $totalMemoryGB = "Non disponible"
    }

    # Récupérer la RAM libre en kilobytes
    $operatingSystem = Get-CimInstance -ClassName Win32_OperatingSystem
    if ($operatingSystem) {
        $freeMemoryKB = $operatingSystem.FreePhysicalMemory
        # Convertir en Go (1 Go = 1,048,576 KB)
        $freeMemoryGB = [math]::Round($freeMemoryKB / 1048576, 2)
    } else {
        $freeMemoryGB = "Non disponible"
    }

    # Calcul de la RAM utilisée
    if ($totalMemoryGB -ne "Non disponible" -and $freeMemoryGB -ne "Non disponible") {
        $usedMemoryGB = [math]::Round($totalMemoryGB - $freeMemoryGB, 2)
    } else {
        $usedMemoryGB = "Non disponible"
    }

    Write-Output "RAM totale : $totalMemoryGB Go"
    Write-Output "RAM utilisée : $usedMemoryGB Go"
    Write-Output "RAM disponible : $freeMemoryGB Go"
} catch {
    Write-Output "RAM totale : Non disponible"
    Write-Output "RAM utilisée : Non disponible"
    Write-Output "RAM disponible : Non disponible"
}

# Récupération des informations détaillées sur chaque module de RAM
try {
    # Utiliser la classe Win32_PhysicalMemory pour obtenir les détails des modules de RAM
    $memoryChips = Get-CimInstance -ClassName Win32_PhysicalMemory

    if ($memoryChips) {
        foreach ($chip in $memoryChips) {
            # BankLabel
            $bankLabel = $chip.BankLabel
            if (-not $bankLabel) {
                $bankLabel = "Non spécifié"
            }

            # Capacity en octets
            $capacity = $chip.Capacity
            if (-not $capacity) {
                $capacity = "Non spécifié"
            }

            # MemoryType avec description via table de correspondance
            $partNumber = $chip.PartNumber
            if ($partNumber -and $partNumberToMemoryType.ContainsKey($partNumber)) {
                $memoryTypeDesc = $partNumberToMemoryType[$partNumber]
                $memoryType = "$memoryTypeDesc"
            } else {
                # Fallback to WMI MemoryType if PartNumber not in table
                $memoryTypeCode = $chip.MemoryType
                $memoryTypeDesc = switch ($memoryTypeCode) {
                    0  { "Unknown" }
                    20 { "DDR3" }
                    21 { "DDR3" }
                    22 { "DDR2" }
                    24 { "DDR4" }
                    26 { "DDR5" }
                    28 { "DDR6" }
                    default { "Code inconnu ($memoryTypeCode)" }
                }
                $memoryType = "$memoryTypeCode ($memoryTypeDesc)"
            }

            # Speed en MHz
            $speed = $chip.Speed
            if (-not $speed) {
                $speed = "Non spécifié"
            } else {
                $speed = "$speed mhz"
            }

            # TypeDetail avec description (bitmask)
            $typeDetailCode = $chip.TypeDetail
            $typeDetailDescList = @()

            # Définir la correspondance des bits pour TypeDetail
            $TypeDetailMap = @{
                1      = "Other"
                2      = "Unknown"
                4      = "Fast-paged"
                8      = "Static column"
                16     = "Pseudo-static"
                32     = "Synchronous"
                64     = "Asynchronous"
                128    = "Reserved"
                256    = "Load reduced"
                512    = "ECC"
                1024   = "Buffered"
                2048   = "Unbuffered"
                4096   = "Registered"
                8192   = "Load-Reduced DIMM"
                16384  = "Unknown flag"
                32768  = "Advanced ECC"
                # Ajouter plus de correspondances si nécessaire
            }

            # Itérer sur les bits définis pour déterminer les flags actifs
            foreach ($bit in $TypeDetailMap.Keys) {
                if ($typeDetailCode -band $bit) {
                    $typeDetailDescList += $TypeDetailMap[$bit]
                }
            }

            # Vérifier les bits non définis
            $mappedBitsSum = ($TypeDetailMap.Keys | Measure-Object -Sum).Sum
            $remainingBits = $typeDetailCode -band (-bnot ($mappedBitsSum))

            if ($remainingBits -ne 0) {
                # Déterminer quels bits sont définis dans les bits restants
                $currentBit = 1
                while ($currentBit -le $remainingBits) {
                    if ($remainingBits -band $currentBit) {
                        $typeDetailDescList += "Unknown bit ($currentBit)"
                    }
                    $currentBit *= 2
                }
            }

            if ($typeDetailDescList.Count -gt 0) {
                $typeDetailDesc = $typeDetailDescList -join ", "
            } else {
                $typeDetailDesc = "Unknown ($typeDetailCode)"
            }

            # Récupérer d'autres informations utiles
            $manufacturer = $chip.Manufacturer

            Write-Output "BankLabel : $bankLabel"
            Write-Output "--> Manufacturer : $manufacturer"
            Write-Output "--> Capacity : $capacity o"
            Write-Output "--> PartNumber : $partNumber"
            Write-Output "--> MemoryType : $memoryType"
            Write-Output "--> Speed : $speed"
        }
    } else {
        Write-Output "Aucun module de RAM détecté."
    }
} catch {
    Write-Output "Erreur lors de la récupération des informations détaillées sur la RAM : $_"
}
