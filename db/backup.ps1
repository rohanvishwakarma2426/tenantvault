$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupDir = ".\db\backups"

if (!(Test-Path $backupDir)) {
    New-Item -ItemType Directory -Path $backupDir | Out-Null
}

$backupFile = "$backupDir\backup_$timestamp.sql"

docker exec tenantvault-db pg_dump -U postgres -d tenantvault | Out-File -FilePath $backupFile -Encoding utf8

Write-Host "Backup created: $backupFile"