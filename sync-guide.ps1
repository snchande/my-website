<#
.SYNOPSIS
    Builds guide.html from markdown files.

.DESCRIPTION
    Reads tutorial.md and git-commands.md, base64-encodes them,
    and generates a fully self-contained guide.html that works
    offline in any browser (Chrome, Edge, Firefox).

.EXAMPLE
    .\sync-guide.ps1
    Run after editing any .md file to rebuild guide.html.
#>

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$guideFile = Join-Path $scriptDir "guide.html"
$templateFile = Join-Path $scriptDir "guide-template.html"
$markedFile = Join-Path $scriptDir "marked.min.js"

# Verify required files
$required = @{
    "guide-template.html" = $templateFile
    "marked.min.js"       = $markedFile
    "tutorial.md"         = Join-Path $scriptDir "tutorial.md"
    "git-commands.md"     = Join-Path $scriptDir "git-commands.md"
}

foreach ($entry in $required.GetEnumerator()) {
    if (-not (Test-Path $entry.Value)) {
        Write-Host "ERROR: $($entry.Key) not found in $scriptDir" -ForegroundColor Red
        exit 1
    }
}

# Read and base64-encode markdown files (normalize line endings first)
$tutorial = (Get-Content (Join-Path $scriptDir "tutorial.md") -Raw) -replace "`r`n", "`n"
$commands = (Get-Content (Join-Path $scriptDir "git-commands.md") -Raw) -replace "`r`n", "`n"

$b64Tutorial = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($tutorial))
$b64Commands = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($commands))

# Read marked.js and template
$markedJs = (Get-Content $markedFile -Raw) -replace "`r`n", "`n"
$template = (Get-Content $templateFile -Raw) -replace "`r`n", "`n"

# Replace placeholders in template
$output = $template
$output = $output.Replace('/* %%MARKED_JS%% */', $markedJs)
$output = $output.Replace('%%TUTORIAL_B64%%', $b64Tutorial)
$output = $output.Replace('%%COMMANDS_B64%%', $b64Commands)

# Write guide.html
[System.IO.File]::WriteAllText($guideFile, $output, [System.Text.UTF8Encoding]::new($false))

$size = [math]::Round((Get-Item $guideFile).Length / 1024)
Write-Host ""
Write-Host "  Built guide.html (${size} KB)" -ForegroundColor Green
Write-Host "  Tutorial: $($tutorial.Length) chars -> $($b64Tutorial.Length) base64" -ForegroundColor DarkGray
Write-Host "  Commands: $($commands.Length) chars -> $($b64Commands.Length) base64" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  Refresh your browser to see changes." -ForegroundColor Cyan
