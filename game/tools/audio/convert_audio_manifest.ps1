param(
    [string]$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path,
    [string]$ManifestPath = 'data\audio\audio_events.json',
    [int]$Quality = 5
)

$ErrorActionPreference = 'Stop'

$ffmpeg = Get-Command ffmpeg -ErrorAction SilentlyContinue
if (-not $ffmpeg) {
    throw 'ffmpeg was not found on PATH. Install ffmpeg or add it to PATH before converting audio.'
}

$manifestFullPath = Join-Path $ProjectRoot $ManifestPath
$manifest = Get-Content -Raw -LiteralPath $manifestFullPath | ConvertFrom-Json

foreach ($eventProperty in $manifest.events.PSObject.Properties) {
    $event = $eventProperty.Value
    if (-not $event.source -or -not $event.path) {
        continue
    }

    $sourcePath = $event.source
    $targetRelative = $event.path -replace '^res://', ''
    $targetPath = Join-Path $ProjectRoot $targetRelative
    $targetDirectory = Split-Path -Parent $targetPath
    New-Item -ItemType Directory -Force -Path $targetDirectory | Out-Null

    if (-not (Test-Path -LiteralPath $sourcePath)) {
        Write-Warning "Missing source for $($eventProperty.Name): $sourcePath"
        continue
    }

    & $ffmpeg.Source -y -hide_banner -loglevel error -i $sourcePath -map_metadata -1 -vn -ac 2 -c:a vorbis -strict -2 -q:a $Quality $targetPath
    if ($LASTEXITCODE -ne 0) {
        throw "ffmpeg failed converting $($eventProperty.Name) from $sourcePath"
    }
    Write-Output "$($eventProperty.Name) -> $targetRelative"
}
