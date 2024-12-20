#!/bin/bash

# Script : system-checker.sh
# Description : Détecte le système d'exploitation, affiche son nom et sa version, et retourne le nom du système pour d'autres scripts.

# Fonction pour afficher l'aide
afficher_aide() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Ce script détecte le système d'exploitation et affiche son nom et sa version."
    echo "Options :"
    echo "  -h, --help   Affiche ce message d'aide"
    echo "  -s, --system Retourne uniquement le nom du système d'exploitation (pour utilisation dans d'autres scripts)."
    echo ""
    echo "Exemple :"
    echo "  ./system-checker.sh"
}

# Gestion des options
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    afficher_aide
    exit 0
fi

# Détection du système d'exploitation
OS=$(uname)

case "$OS" in
    Darwin)
        SYSTEM_NAME="macOS"
        SYSTEM_VERSION=$(sw_vers -productVersion)
        ;;
    Linux)
        SYSTEM_NAME="Linux"
        SYSTEM_VERSION=$(lsb_release -d 2>/dev/null | awk -F':' '{print $2}' | xargs || uname -r)
        ;;
    CYGWIN*|MINGW*|MSYS*)
        SYSTEM_NAME="Windows"
        SYSTEM_VERSION=$(powershell.exe -Command "(Get-CimInstance Win32_OperatingSystem).Caption" | xargs)
        ;;
    *)
        SYSTEM_NAME="Inconnu"
        SYSTEM_VERSION="Inconnue"
        ;;
esac

# Option : Retourner uniquement le nom du système
if [[ "$1" == "--system" || "$1" == "-s" ]]; then
    echo "$SYSTEM_NAME"
    exit 0
fi

# Affichage des informations du système
echo "Système d'exploitation : $SYSTEM_NAME"
echo "Version : $SYSTEM_VERSION"
