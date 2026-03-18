function Initialize-RobCoStructure {
    param(
        [Parameter(Mandatory)]
        [string]$RootPath
    )

    $requiredPaths = @(
        'assets',
        'assets/core',
        'assets/mods'
    )

    foreach ($relativePath in $requiredPaths) {
        $fullPath = Join-Path $RootPath $relativePath

        if (-not (Test-Path -LiteralPath $fullPath)) {
            New-Item -ItemType Directory -Path $fullPath | Out-Null
        }
    }
}


function Get-RobCoMods {
    param(
        [Parameter(Mandatory)]
        [string]$ModsPath
    )

    if (-not (Test-Path -LiteralPath $ModsPath)) {
        return @()
    }

    $modFolders = Get-ChildItem -Path $ModsPath -Directory

    $mods = foreach ($folder in $modFolders) {
        $manifestPath = Join-Path $folder.FullName 'manifest.json'

        if (Test-Path -LiteralPath $manifestPath) {
            $manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json

            [pscustomobject]@{
                Name = $manifest.name
                Version = $manifest.version
                Path = $folder.FullName
                RunPath = (Join-Path $folder.FullName 'run.ps1')
            }
        } else {
            [pscustomobject]@{
                Name = $folder.Name
                Version = 'unknown'
                Path = $folder.FullName
                RunPath = (Join-Path $folder.FullName 'run.ps1')
            }
        }
    }

    return @($mods)
}