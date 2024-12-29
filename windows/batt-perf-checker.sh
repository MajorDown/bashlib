#!/bin/bash

# Script : batt-perf-checker.sh
# Description :
#   Teste la performance de la batterie en comparant son pourcentage
#   avant et après 10 minutes de lecture vidéo sur YouTube.
#   Un compteur s’affiche en temps réel sur une seule ligne pendant ces 10 minutes.
#
# Usage :
#   bash batt-perf-checker.sh

echo "----------------------------------------"
echo "-- TEST DE PERFORMANCE DE LA BATTERIE --"

# 1. Vérification de la connexion Internet
ping -n 1 google.com > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
    echo "Erreur : Pas de connexion Internet. Veuillez vérifier votre réseau."
    exit 1
fi

echo "Connexion Internet détectée. Poursuite du test."

# 2. Demande d'autorisation
read -p "Ce test lancera une vidéo sur YouTube pendant 10 minutes. Continuer ? (o/N) : " confirm
if [[ "$confirm" != "o" && "$confirm" != "O" ]]; then
    echo "Test annulé."
    exit 0
fi

# 3. Capture du pourcentage initial
initial_percentage=$(powershell.exe -Command "(Get-WmiObject -Class Win32_Battery).EstimatedChargeRemaining")
echo "Pourcentage initial de la batterie : ${initial_percentage}%"

# 4. Paramètres de la vidéo
url="https://www.youtube.com/watch?v=jIQ6UV2onyI&t=488s"
total_seconds=600  # 10 minutes = 600 secondes

# 5. Taille/position de la fenêtre Chrome
window_width=800
window_height=600

# 6. Profil temporaire pour isoler l'instance Chrome
profile_path="C:\\Users\\$USERNAME\\AppData\\Local\\Temp\\test-profile-$$"

# -- AJOUT -- : Définir un flag personnalisé
marker="battPerfMarker_$$"

# 7. Lancement de Chrome avec ce profil dédié + flag personnalisé
"C:\Program Files\Google\Chrome\Application\chrome.exe" \
  --app="$url" \
  --window-size=${window_width},${window_height} \
  --user-data-dir="$profile_path" \
  --batt-perf-marker="$marker" \
  > /dev/null 2>&1 &

# 8. Compte à rebours (affichage en temps réel sur une seule ligne)
for (( i=$total_seconds; i>0; i-- )); do
    minutes=$((i / 60))
    seconds=$((i % 60))
    echo -ne "Il reste $minutes minute(s) et $seconds seconde(s) avant la fin du test...\r"
    sleep 1
done
echo -e "\nFin du décompte."

# 9. Clôture ciblée des processus Chrome correspondant à ce marker
#    On redirige stderr vers /dev/null pour masquer les éventuels messages "Demande non valide"
pids=$(wmic process where "CommandLine like '%$marker%'" get ProcessId /format:value 2>/dev/null \
       | grep "ProcessId=" \
       | sed 's/ProcessId=//')

for pid in $pids; do
    taskkill //PID $pid //F > /dev/null 2>&1
done

# 10. Capture du pourcentage final
final_percentage=$(powershell.exe -Command "(Get-WmiObject -Class Win32_Battery).EstimatedChargeRemaining")
echo "Pourcentage final   : ${final_percentage}%"
consumption=$((initial_percentage - final_percentage))
echo "Consommation pendant le test : ${consumption}%"
