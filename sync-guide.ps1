<#
.SYNOPSIS
    Syncs markdown files into guide.html embedded content.

.DESCRIPTION
    Reads tutorial.md and git-commands.md from the same folder,
    then replaces the embedded <script type="text/markdown"> blocks
    inside guide.html so offline Chrome/Edge viewing stays in sync.

.EXAMPLE
    .\sync-guide.ps1
    Run from the my-website folder after editing any .md file.
#>

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$guideFile = Join-Path $scriptDir "guide.html"

# Map: embedded script tag ID -> markdown file
$mdMap = @{
    "embedded-tutorial" = Join-Path $scriptDir "tutorial.md"
    "embedded-commands" = Join-Path $scriptDir "git-commands.md"
}

# Verify all files exist
if (-not (Test-Path $guideFile)) {
    Write-Host "ERROR: guide.html not found in $scriptDir" -ForegroundColor Red
    exit 1
}

foreach ($entry in $mdMap.GetEnumerator()) {
    if (-not (Test-Path $entry.Value)) {
        Write-Host "ERROR: $($entry.Value) not found" -ForegroundColor Red
        exit 1
    }
}

# Read guide.html
$html = Get-Content $guideFile -Raw -Encoding UTF8

foreach ($entry in $mdMap.GetEnumerator()) {
    $id = $entry.Key
    $mdFile = $entry.Value
    $mdContent = Get-Content $mdFile -Raw -Encoding UTF8

    # Pattern: everything between <script type="text/markdown" id="ID"> and </script>
    $pattern = "(?s)(<script type=`"text/markdown`" id=`"$id`">)(.*?)(</script>)"
    
    if ($html -match $pattern) {
        $html = $html -replace $pattern, "`${1}`n$mdContent`n`${3}"
        Write-Host "  Synced: $($entry.Value | Split-Path -Leaf) -> #$id" -ForegroundColor Green
    } else {
        Write-Host "  WARNING: Could not find embedded block #$id in guide.html" -ForegroundColor Yellow
    }
}

# Write updated guide.html
Set-Content -Path $guideFile -Value $html -Encoding UTF8 -NoNewline
Write-Host ""
Write-Host "guide.html updated! Refresh your browser to see changes." -ForegroundColor Cyan
