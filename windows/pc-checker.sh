#!/bin/bash

# Script : pc-info.sh
# Description : Récupère la marque, le modèle et le numéro de série du PC sous Windows
# Exemple d’exécution :
#   bash pc-info.sh
# -----------------------------
# -- INFORMATIONS SUR LE PC --
# Marque : LENOVO
# Modèle : ThinkPad T14 Gen 2
# Numéro de série : ABC123XYZ
# -----------------------------

echo "-----------------------------"
echo "-- INFORMATIONS SUR L'APPAREIL --"

# Récupération de la marque (Vendor)
marque=$(wmic csproduct get Vendor | awk 'NR==2 && NF > 0 {
  for (i=1; i<=NF; i++) {
    printf $i
    if (i < NF) printf " "
  }
}')
echo "Marque : $marque"

# Récupération du modèle (Name)
modele=$(wmic csproduct get Name | awk 'NR==2 && NF > 0 {
  for (i=1; i<=NF; i++) {
    printf $i
    if (i < NF) printf " "
  }
}')
echo "Modèle : $modele"

# Récupération du numéro de série (SerialNumber)
serial_number=$(wmic BIOS get SerialNumber | awk 'NR==2 && NF > 0 {
  for (i=1; i<=NF; i++) {
    printf $i
    if (i < NF) printf " "
  }
}')
echo "Numéro de série : $serial_number"

echo "-----------------------------"
