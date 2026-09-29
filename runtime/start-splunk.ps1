$ErrorActionPreference = 'Stop'

$startupTimeoutSeconds = 300
if ($env:SPLUNK_DOCKER_STARTUP_TIMEOUT_SECONDS) {
    $parsedTimeout = 0
    if (-not [int]::TryParse($env:SPLUNK_DOCKER_STARTUP_TIMEOUT_SECONDS, [ref]$parsedTimeout) -or
        $parsedTimeout -lt 1 -or $parsedTimeout -gt 1800) {
        throw 'SPLUNK_DOCKER_STARTUP_TIMEOUT_SECONDS must be an integer between 1 and 1800.'
    }
    $startupTimeoutSeconds = $parsedTimeout
}

$projectRoot = Split-Path -Parent $PSScriptRoot
$composeFile = Join-Path $PSScriptRoot 'docker-compose.yml'
$envFile = Join-Path $projectRoot '.env'

if (-not (Test-Path $composeFile -PathType Leaf)) {
    throw "Docker Compose file not found: $composeFile"
}

if (-not (Test-Path $envFile -PathType Leaf)) {
    throw "Environment file not found: $envFile"
}

$dockerCommand = Get-Command docker -CommandType Application -ErrorAction Stop |
    Select-Object -First 1
$dockerPath = $dockerCommand.Source

function Test-DockerEngine {
    $null = & $dockerPath info --format '{{.ServerVersion}}' 2>$null
    return $LASTEXITCODE -eq 0
}

if (-not (Test-DockerEngine)) {
    $candidates = @(
        (Join-Path $env:ProgramFiles 'Docker\Docker\Docker Desktop.exe'),
        (Join-Path ${env:ProgramFiles(x86)} 'Docker\Docker\Docker Desktop.exe'),
        (Join-Path $env:LOCALAPPDATA 'Programs\Docker\Docker\Docker Desktop.exe')
    )

    $dockerDesktopPath = $candidates |
        Where-Object { $_ -and (Test-Path $_ -PathType Leaf) } |
        Select-Object -First 1

    if (-not $dockerDesktopPath) {
        throw 'Docker Engine is unavailable and Docker Desktop.exe could not be found. Start Docker Desktop manually.'
    }

    Write-Host 'Docker Engine unavailable; starting Docker Desktop...'
    Start-Process -FilePath $dockerDesktopPath

    $timer = [System.Diagnostics.Stopwatch]::StartNew()
    while ($timer.Elapsed.TotalSeconds -lt $startupTimeoutSeconds) {
        Start-Sleep -Seconds 5
        if (Test-DockerEngine) {
            break
        }
    }

    if (-not (Test-DockerEngine)) {
        throw "Docker Engine did not become ready within $startupTimeoutSeconds seconds. Check Docker Desktop and its selected container engine."
    }
}

$composeArgs = @($args)
if (-not $composeArgs -or $composeArgs.Count -eq 0) {
    $composeArgs = @('up', '-d')
}

Write-Host 'Docker Engine is ready; running Docker Compose.'
Push-Location $projectRoot
try {
    & $dockerPath compose --env-file $envFile -f $composeFile @composeArgs
    if ($LASTEXITCODE -ne 0) {
        throw "docker compose failed with exit code $LASTEXITCODE."
    }
}
finally {
    Pop-Location
}
