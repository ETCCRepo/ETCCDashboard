param([string]$File = "", [switch]$NoVersionBump)

$FTP_HOST = "ftp.etccapps.com"
$utf8nobom = [System.Text.UTF8Encoding]::new($false)

# Guard: credentials file must exist
if (-not (Test-Path "$PSScriptRoot\.ftp-credentials")) {
    Write-Host "ERROR: .ftp-credentials not found. Cannot deploy."; exit 1
}

# Read credentials from .ftp-credentials
$creds = @{}
Get-Content "$PSScriptRoot\.ftp-credentials" | ForEach-Object {
    if ($_ -match "^login (.+)$")    { $lastLogin = $Matches[1] }
    if ($_ -match "^password (.+)$") { $creds[$lastLogin] = $Matches[1] }
}
$FTP_USER      = "u177039107.dashboard"
$FTP_PASS      = $creds[$FTP_USER]
$FTP_USER_ROOT = "u177039107"
$FTP_PASS_ROOT = $creds[$FTP_USER_ROOT]

if (-not $FTP_PASS -or -not $FTP_PASS_ROOT) {
    Write-Host "ERROR: One or more FTP credentials missing from .ftp-credentials."; exit 1
}

# Only auto-increment version and update sitemap on full deploy (unless -NoVersionBump)
if (-not $File -and -not $NoVersionBump) {
    # Bump version in index.html
    $indexPath = Join-Path $PSScriptRoot "index.html"
    $content = [System.IO.File]::ReadAllText($indexPath, [System.Text.Encoding]::UTF8)
    if ($content -match 'Version: (\d+)\.(\d+)') {
        $major = $Matches[1]
        $minor = [int]$Matches[2] + 1
        $newDate  = (Get-Date).ToString("MMM d, yyyy h:mm tt")
        $lastmod  = (Get-Date).ToString("yyyy-MM-dd")
        $updated  = $content -replace 'Version: \d+\.\d+ &nbsp;&middot;&nbsp; Date: <time datetime="[^"]*">[^<]+</time>', "Version: $major.$minor &nbsp;&middot;&nbsp; Date: <time datetime=`"$lastmod`">$newDate</time>"
        if ($updated -ne $content) {
            [System.IO.File]::WriteAllText($indexPath, $updated, $utf8nobom)
            Write-Host "Version bumped to $major.$minor  Date: $newDate"
        }
    }

    # Update lastmod in sitemap.xml (BOM-free)
    $sitemapPath = Join-Path $PSScriptRoot "sitemap.xml"
    if (Test-Path $sitemapPath) {
        $sitemap = [System.IO.File]::ReadAllText($sitemapPath)
        $lastmod = (Get-Date).ToString("yyyy-MM-dd")
        $sitemap = $sitemap -replace '<lastmod>[^<]+</lastmod>', "<lastmod>$lastmod</lastmod>"
        [System.IO.File]::WriteAllText($sitemapPath, $sitemap, $utf8nobom)
        Write-Host "Sitemap lastmod updated to $lastmod"
    }
}

function Upload($localRel, $user, $pass, $remoteName) {
    $localPath = Join-Path $PSScriptRoot $localRel
    if (-not (Test-Path $localPath)) { Write-Host "SKIP: $localRel not found"; return }
    $url = "ftp://${FTP_HOST}/${remoteName}"
    Write-Host "Uploading $localRel -> $url"
    $result = curl.exe -s -S -T $localPath -u "${user}:${pass}" $url 2>&1
    if ($LASTEXITCODE -eq 0) { Write-Host "  OK" } else { Write-Host "  ERROR: $result" }
}

# Files deployed to dashboard subuser (public_html/apps/dashboard/)
$dashboardFiles = @(
    @{ local="index.html";            remote="index.html" },
    @{ local="favicon.ico";           remote="favicon.ico" },
    @{ local="ETCClogo.png";          remote="ETCClogo.png" },
    @{ local="test.html";             remote="test.html" },
    @{ local="404.html";              remote="404.html" },
    @{ local="robots-dashboard.txt";  remote="robots.txt" },
    @{ local="sitemap.xml";           remote="sitemap.xml" }
)

# Files deployed to root account (public_html/)
$rootFiles = @(
    @{ local="htaccess-root/.htaccess"; remote="domains/etccapps.com/public_html/.htaccess" },
    @{ local="test.html";               remote="domains/etccapps.com/public_html/test.html" },
    @{ local="robots.txt";              remote="domains/etccapps.com/public_html/robots.txt" },
    @{ local="sitemap.xml";             remote="domains/etccapps.com/public_html/sitemap.xml" }
)

if ($File) {
    $dashEntry = $dashboardFiles | Where-Object { $_.local -eq $File }
    $rootEntry = $rootFiles      | Where-Object { $_.local -eq $File }
    if ($rootEntry)     { Upload $rootEntry.local  $FTP_USER_ROOT $FTP_PASS_ROOT $rootEntry.remote }
    elseif ($dashEntry) { Upload $dashEntry.local  $FTP_USER      $FTP_PASS      $dashEntry.remote }
    else { Write-Host "Unknown file: $File - not in dashboardFiles or rootFiles."; exit 1 }
} else {
    foreach ($f in $dashboardFiles) { Upload $f.local $FTP_USER      $FTP_PASS      $f.remote }
    foreach ($r in $rootFiles)      { Upload $r.local $FTP_USER_ROOT $FTP_PASS_ROOT $r.remote }
}

Write-Host ""
Write-Host "Deploy complete."
Write-Host "  https://etccapps.com"
Write-Host "  https://dashboard.etccapps.com/"
