#!/bin/bash

# Script : global-checker.sh
# Description : Détecte le système d'exploitation et exécute les scripts adaptés dans le bon dossier.
# Usage : bash global-checker.sh

echo "-----------------------------------------"
echo "-- DÉTECTION DU SYSTÈME D'EXPLOITATION --"

# Détection du système d'exploitation
OS=$(uname)

case "$OS" in
    Darwin)
        SYSTEM_NAME="mac"
        SYSTEM_VERSION=$(sw_vers -productVersion)
        ;;
    Linux)
        SYSTEM_NAME="linux"
        SYSTEM_VERSION=$(lsb_release -d 2>/dev/null | awk -F':' '{print $2}' | xargs || uname -r)
        ;;
    CYGWIN*|MINGW*|MSYS*)
        SYSTEM_NAME="windows"
        SYSTEM_VERSION=$(powershell.exe -Command "(Get-CimInstance Win32_OperatingSystem).Caption" | xargs)
        ;;
    *)
        echo "Système d'exploitation non pris en charge."
        exit 1
        ;;
esac

echo "Système détecté : $SYSTEM_NAME"
echo "version : $SYSTEM_VERSION"

# Chemin vers les scripts en fonction du système
SCRIPT_DIR="./$SYSTEM_NAME"

# Liste des scripts à exécuter
SCRIPTS=(
    "pc-checker.sh"
    "cpu-checker.sh"
    "disk-checker.sh"
    "ram-checker.sh"
    "periph-checker.sh"
    "batt-checker.sh"
    "batt-perf-checker.sh"
)

# Vérification et exécution des scripts
for script in "${SCRIPTS[@]}"; do
    SCRIPT_PATH="$SCRIPT_DIR/$script"
    if [[ -f "$SCRIPT_PATH" ]]; then
        bash "$SCRIPT_PATH"
    else
        echo "Erreur : Script non trouvé -> $SCRIPT_PATH"
    fi
done

echo "-----------------------------"
echo "-- CHECKUP GLOBAL TERMINÉE --"
