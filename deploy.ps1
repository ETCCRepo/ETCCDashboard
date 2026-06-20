param([string]$File = "")

$FTP_HOST = "ftp.etccapps.com"
$FTP_USER = "u177039107.dashboard"
$FTP_PASS = (Get-Content "$PSScriptRoot\.ftp-credentials" | Where-Object { $_ -match "^password " }) -replace "^password ", ""

$allFiles = @("index.html", "ETCClogo.png", "test.html")
$toUpload = if ($File) { @($File) } else { $allFiles }

foreach ($f in $toUpload) {
    $localPath = Join-Path $PSScriptRoot $f
    if (-not (Test-Path $localPath)) {
        Write-Host "SKIP: $f not found"
        continue
    }
    $remotePath = "ftp://${FTP_HOST}/${f}"
    Write-Host "Uploading $f -> $remotePath"
    $result = curl.exe -s -S -T $localPath -u "${FTP_USER}:${FTP_PASS}" $remotePath 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  OK: $f deployed"
    } else {
        Write-Host "  ERROR: $f failed - $result"
    }
}

Write-Host ""
Write-Host "Deploy complete. Live at: https://etccapps.com/apps/dashboard/"
