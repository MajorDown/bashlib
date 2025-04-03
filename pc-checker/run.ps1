[Console]::OutputEncoding = [System.Text.Encoding]::UTF8


Write-Host "Compilation du projet..."
if (!(Test-Path "out")) {
    New-Item -ItemType Directory -Path "out" | Out-Null
}

# Concatène tous les .jar dans lib/
$classpath = (Get-ChildItem -Path lib -Filter *.jar | ForEach-Object { "lib\\$($_.Name)" }) -join ";"

javac -cp $classpath -d out (Get-ChildItem -Recurse -Filter *.java | ForEach-Object { $_.FullName })

if ($LASTEXITCODE -eq 0) {
    Write-Host "Compilation réussie. Lancement..."
    java -cp "out;$classpath" com.pcchecker.Main
}
else {
    Write-Host "Erreur de compilation."
}
