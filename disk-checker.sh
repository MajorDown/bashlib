#!/bin/bash

# Script : disk-checker.sh
# Description : Vérifie les informations sur les disques en fonction du système d'exploitation détecté.

# Fonction pour afficher l'aide
afficher_aide() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Ce script collecte des informations sur les disques selon l'OS détecté."
    echo "Options :"
    echo "  -h, --help   Affiche ce message d'aide"
    echo ""
    echo "Exemple :"
    echo "  ./disk-checker.sh"
}

# Vérification des options
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    afficher_aide
    exit 0
fi

# Détection du système d'exploitation
OS=$(uname)

# Vérification des disques en fonction de l'OS
case "$OS" in
    Darwin)
        echo "--- Informations Disques ---"
        diskutil list
        ;;

    Linux)
        echo "--- Informations Disques ---"
        lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,MODEL
        ;;

    CYGWIN*|MINGW*|MSYS*)
        echo "--- Informations Disques ---"
        powershell.exe -Command "Get-PhysicalDisk | Format-Table DeviceID,FriendlyName,MediaType,OperationalStatus,HealthStatus,Size -AutoSize"
        ;;

    *)
        echo "Erreur : Système d'exploitation non pris en charge."
        exit 1
        ;;
esac
