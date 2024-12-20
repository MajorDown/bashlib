#!/bin/bash

# Script : ram-checker.sh
# Description : Vérifie les informations sur la RAM en fonction du système d'exploitation détecté.

# Fonction pour afficher l'aide
afficher_aide() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Ce script collecte des informations sur la RAM selon l'OS détecté."
    echo "Options :"
    echo "  -h, --help   Affiche ce message d'aide"
    echo ""
    echo "Exemple :"
    echo "  ./ram-checker.sh"
}

# Vérification des options
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    afficher_aide
    exit 0
fi

# Détection du système d'exploitation
OS=$(uname)

# Vérification des informations RAM en fonction de l'OS
case "$OS" in
    Darwin)
        echo "--- Informations RAM ---"
        vm_stat | awk '/free/ {print "RAM libre : " $3*4096/1024/1024 " Mo"}'
        ;;

    Linux)
        echo "--- Informations RAM ---"
        free -h | awk '/Mem:/ {print "RAM totale : "$2"\nRAM utilisée : "$3}'
        ;;

    CYGWIN*|MINGW*|MSYS*)
        echo "--- Informations RAM ---"
        powershell.exe -Command "Get-CimInstance Win32_OperatingSystem | Select-Object TotalVisibleMemorySize,FreePhysicalMemory | Format-List"
        ;;

    *)
        echo "Erreur : Système d'exploitation non pris en charge."
        exit 1
        ;;
esac
