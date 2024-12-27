#!/bin/bash

# Script : batt-perf-checker.sh
# Description : Teste la performance de la batterie en comparant son pourcentage avant et après 10 minutes de lecture vidéo.
# Usage : bash batt-perf-checker.sh

echo "----------------------------------------"
echo "-- TEST DE PERFORMANCE DE LA BATTERIE --"

# Vérification de la connexion Internet
ping -n 1 google.com > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
    echo "Erreur : Pas de connexion Internet. Veuillez vérifier votre réseau."
    exit 1
fi

echo "Connexion Internet détectée. Poursuite du test."

# Demande d'autorisation
read -p "Ce test lancera une vidéo sur YouTube pendant 10 minutes. Continuer ? (o/N) : " confirm
if [[ "$confirm" != "o" && "$confirm" != "O" ]]; then
    echo "Test annulé."
    exit 0
fi

# Capture le pourcentage initial
initial_percentage=$(powershell.exe -Command "(Get-WmiObject -Class Win32_Battery).EstimatedChargeRemaining")
echo "Pourcentage initial de la batterie : ${initial_percentage}%"

# URL de la vidéo spécifiée
url="https://www.youtube.com/watch?v=jIQ6UV2onyI&t=488s" # Vidéo 4K officielle pour tests YouTube
timeout=600 # 10 minutes en secondes

# Définir la taille et position de la fenêtre
window_width=800
window_height=600

# Ouvrir Chrome dans une nouvelle fenêtre indépendante avec la taille spécifiée
"C:\Program Files\Google\Chrome\Application\chrome.exe" \
--app="$url" --window-size=${window_width},${window_height} \
--user-data-dir=/tmp/test-profile > /dev/null 2>&1 &
pid=$! # Capture le PID du processus lancé

# Attendre 10 minutes
sleep $timeout

# Fermer la fenêtre Chrome spécifique ouverte par le script
taskkill //IM chrome.exe //F > /dev/null 2>&1

# Capture le pourcentage final
final_percentage=$(powershell.exe -Command "(Get-WmiObject -Class Win32_Battery).EstimatedChargeRemaining")
echo "Pourcentage final de la batterie : ${final_percentage}%"

# Comparaison
echo "----------------------------------------"
echo "-- RÉSULTATS DU TEST --"
echo "Pourcentage initial : ${initial_percentage}%"
echo "Pourcentage final   : ${final_percentage}%"
consumption=$((initial_percentage - final_percentage))
echo "Consommation pendant le test : ${consumption}%"
