# Script : batt-perf-checker.ps1
# Description :
#   Teste la performance de la batterie en comparant son pourcentage
#   avant et après 10 minutes de lecture vidéo sur YouTube.
#   Un compteur s’affiche en temps réel sur une seule ligne pendant ces 10 minutes.
#
# Usage :
#   .\batt-perf-checker.ps1

# Affichage des en-têtes
Write-Output "----------------------------------------"
Write-Output "-- TEST DE PERFORMANCE DE LA BATTERIE --"

# 1. Vérification de la connexion Internet
$pingResult = Test-Connection -ComputerName "google.com" -Count 1 -Quiet

if (-not $pingResult) {
    Write-Output "Erreur : Pas de connexion Internet. Veuillez vérifier votre réseau."
    exit 1
}

Write-Output "Connexion Internet détectée. Poursuite du test."

# 2. Demande d'autorisation
$confirm = Read-Host "Ce test lancera une vidéo sur YouTube pendant 10 minutes. Continuer ? (o/N) :"

if ($confirm -ne 'o' -and $confirm -ne 'O') {
    Write-Output "Test annulé."
    exit 0
}

# 3. Capture du pourcentage initial
$batteryInitial = Get-CimInstance -ClassName Win32_Battery

if ($batteryInitial) {
    $initial_percentage = $batteryInitial.EstimatedChargeRemaining
    Write-Output "Pourcentage initial de la batterie : ${initial_percentage}%"
} else {
    Write-Output "Aucune batterie détectée."
    exit 1
}

# 4. Paramètres de la vidéo
$url = "https://www.youtube.com/watch?v=jIQ6UV2onyI&t=488s"
$total_seconds = 600  # 10 minutes = 600 secondes

# 5. Taille/position de la fenêtre Chrome
$window_width = 800
$window_height = 600

# 6. Profil temporaire pour isoler l'instance Chrome
$profile_path = "C:\Users\$($env:USERNAME)\AppData\Local\Temp\test-profile-$PID"

# 7. Définir un flag personnalisé
$marker = "battPerfMarker_$PID"

# 8. Lancement de Chrome avec ce profil dédié + flag personnalisé
$chromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"

if (Test-Path $chromePath) {
    Start-Process -FilePath $chromePath -ArgumentList @(
        "--app=$url",
        "--window-size=$window_width,$window_height",
        "--user-data-dir=$profile_path",
        "--batt-perf-marker=$marker"
    ) | Out-Null
    Write-Output "Lancement de Chrome pour lire la vidéo."
} else {
    Write-Output "Erreur : Google Chrome n'est pas installé à l'emplacement spécifié."
    exit 1
}

# 9. Compte à rebours (affichage en temps réel sur une seule ligne)
for ($i = $total_seconds; $i -gt 0; $i--) {
    $minutes = [math]::Floor($i / 60)
    $seconds = $i % 60
    $countdown = "Il reste $minutes minute(s) et $seconds seconde(s) avant la fin du test..."

    # Réinitialiser le curseur au début de la ligne avec `r
    Write-Host "`r$countdown" -NoNewline

    Start-Sleep -Seconds 1
}
Write-Host "`nFin du décompte."

# 10. Clôture ciblée des processus Chrome correspondant à ce marker
# Récupérer les processus Chrome avec le marker dans la ligne de commande
$chromeProcesses = Get-CimInstance -ClassName Win32_Process | Where-Object { $_.CommandLine -like "*$marker*" }

foreach ($process in $chromeProcesses) {
    try {
        Stop-Process -Id $process.ProcessId -Force -ErrorAction SilentlyContinue
        Write-Output "Processus Chrome (PID: $($process.ProcessId)) fermé."
    } catch {
        Write-Output "Erreur lors de l'arrêt du processus $($process.ProcessId) : $_"
    }
}

# 11. Capture du pourcentage final
$batteryFinal = Get-CimInstance -ClassName Win32_Battery

if ($batteryFinal) {
    $final_percentage = $batteryFinal.EstimatedChargeRemaining
    Write-Output "Pourcentage final   : ${final_percentage}%"
    $consumption = $initial_percentage - $final_percentage
    Write-Output "Consommation pendant le test : ${consumption}%"
} else {
    Write-Output "Aucune batterie détectée après le test."
    exit 1
}
