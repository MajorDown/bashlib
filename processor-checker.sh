#!/bin/bash

# Script : processor-checker.sh
# Description : Vérifie les informations sur le processeur en fonction du système d'exploitation détecté.

# Fonction pour afficher l'aide
afficher_aide() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Ce script collecte des informations sur le processeur selon l'OS détecté."
    echo "Options :"
    echo "  -h, --help   Affiche ce message d'aide"
    echo ""
    echo "Exemple :"
    echo "  ./processor-checker.sh"
}

# Vérification des options
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    afficher_aide
    exit 0
fi

# Détection du système d'exploitation
OS=$(uname)

# Vérification des informations processeur en fonction de l'OS
case "$OS" in
    Darwin)
        echo "--- Informations Processeur ---"
        sysctl -n machdep.cpu.brand_string
        ;;

    Linux)
        echo "--- Informations Processeur ---"
        lscpu | grep -E "Model name|^CPU\(s\):"
        ;;

    CYGWIN*|MINGW*|MSYS*)
        echo "--- Informations Processeur ---"
        powershell.exe -Command "Get-WmiObject Win32_Processor | Format-Table Name,NumberOfCores,MaxClockSpeed -AutoSize"
        ;;

    *)
        echo "Erreur : Système d'exploitation non pris en charge."
        exit 1
        ;;
esac
