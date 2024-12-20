#!/bin/bash

# Script : battery-checker.sh
# Description : Vérifie les informations sur la batterie et affiche la capacité nominale (Design Capacity) et la capacité actuelle maximale (Full Charge Capacity) en fonction du système d'exploitation détecté.

# Fonction pour afficher l'aide
afficher_aide() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Ce script collecte des informations sur la batterie et affiche DesignCapacity et FullChargeCapacity."
    echo "Options :"
    echo "  -h, --help   Affiche ce message d'aide"
    echo ""
    echo "Exemple :"
    echo "  ./battery-checker.sh"
}

# Vérification des options
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    afficher_aide
    exit 0
fi

# Détection du système d'exploitation
OS=$(uname)

# Vérification des informations batterie en fonction de l'OS
case "$OS" in
    Darwin)
        echo "--- Informations Batterie (macOS) ---"
        DESIGN_CAPACITY=$(ioreg -l | grep -i "DesignCapacity" | awk '{print $5}')
        FULL_CHARGE_CAPACITY=$(ioreg -l | grep -i "MaxCapacity" | awk '{print $5}')
        echo "Design Capacity : $DESIGN_CAPACITY"
        echo "Full Charge Capacity : $FULL_CHARGE_CAPACITY"
        ;;

    Linux)
        echo "--- Informations Batterie (Linux) ---"
        if command -v upower &> /dev/null; then
            DEVICE=$(upower -e | grep battery | head -n 1)
            if [ -n "$DEVICE" ]; then
                DESIGN_CAPACITY=$(upower -i "$DEVICE" | grep "energy-full-design" | awk '{print $2}')
                FULL_CHARGE_CAPACITY=$(upower -i "$DEVICE" | grep "energy-full" | awk '{print $2}')
                echo "Design Capacity : $DESIGN_CAPACITY"
                echo "Full Charge Capacity : $FULL_CHARGE_CAPACITY"
            else
                echo "Aucune batterie détectée."
            fi
        else
            echo "L'outil 'upower' n'est pas installé. Veuillez l'installer pour collecter des informations sur la batterie."
        fi
        ;;

    CYGWIN*|MINGW*|MSYS*)
        echo "--- Informations Batterie (Windows) ---"
        DESIGN_CAPACITY=$(powershell.exe -Command "(Get-WmiObject Win32_Battery | Select-Object -ExpandProperty DesignCapacity) -join ''")
        FULL_CHARGE_CAPACITY=$(powershell.exe -Command "(Get-WmiObject Win32_Battery | Select-Object -ExpandProperty FullChargeCapacity) -join ''")
        echo "Design Capacity : $DESIGN_CAPACITY"
        echo "Full Charge Capacity : $FULL_CHARGE_CAPACITY"
        ;;

    *)
        echo "Erreur : Système d'exploitation non pris en charge."
        exit 1
        ;;
esac
