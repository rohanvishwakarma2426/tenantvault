param(
    [Parameter(Mandatory=$true)]
    [string]$BackupFile
)

Get-Content $BackupFile | docker exec -i tenantvault-db psql -U postgres -d tenantvault

Write-Host "Restore complete from: $BackupFile"