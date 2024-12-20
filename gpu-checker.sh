#!/bin/bash

# Script : gpu-checker.sh
# Description : Vérifie les informations sur le GPU en fonction du système d'exploitation détecté.

# Fonction pour afficher l'aide
afficher_aide() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Ce script collecte des informations sur le GPU selon l'OS détecté."
    echo "Options :"
    echo "  -h, --help   Affiche ce message d'aide"
    echo ""
    echo "Exemple :"
    echo "  ./gpu-checker.sh"
}

# Vérification des options
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    afficher_aide
    exit 0
fi

# Détection du système d'exploitation
OS=$(uname)

# Vérification des informations GPU en fonction de l'OS
case "$OS" in
    Darwin)
        echo "--- Informations GPU ---"
        system_profiler SPDisplaysDataType | grep "Chipset Model"
        ;;

    Linux)
        echo "--- Informations GPU ---"
        lspci | grep -i vga
        ;;

    CYGWIN*|MINGW*|MSYS*)
        echo "--- Informations GPU ---"
        powershell.exe -Command "Get-WmiObject Win32_VideoController | Format-Table Name,AdapterRAM -AutoSize"
        ;;

    *)
        echo "Erreur : Système d'exploitation non pris en charge."
        exit 1
        ;;
esac
