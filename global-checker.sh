#!/bin/bash

# Script : global-checker.sh
# Description : Exécute tous les scripts checker l'un après l'autre.

# Liste des scripts à exécuter
SCRIPTS=(
    "./system-checker.sh"
    "./disk-checker.sh"
    "./ram-checker.sh"
    "./processor-checker.sh"
    "./gpu-checker.sh"
    "./batt-checker.sh"
)

# Exécution des scripts
for SCRIPT in "${SCRIPTS[@]}"; do
    if [[ -x "$SCRIPT" ]]; then
        $SCRIPT
    else
        echo "Erreur : $SCRIPT n'est pas exécutable ou introuvable."
    fi
done

# Fin
echo "--- Tous les checkers ont été exécutés ---"
