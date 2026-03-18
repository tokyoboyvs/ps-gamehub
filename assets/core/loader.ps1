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

            $_name = 'unknown'
            $_version = 'unknown'
            $_description = 'No description.'
            $_author = 'unknown'
            $_entryPoint = 'run.ps1'

            if ($null -ne ($manifest.PSObject.Properties['name'])) {
                $_name = $manifest.name
            }

            if ($null -ne ($manifest.PSObject.Properties['version'])) {
                $_version = $manifest.version
            }

            if ($null -ne ($manifest.PSObject.Properties['description'])) {
                $_description = $manifest.description
            }

            if ($null -ne ($manifest.PSObject.Properties['author'])) {
                $_author = $manifest.author
            }

            if ($null -ne ($manifest.PSObject.Properties['entryPoint'])) {
                $_entryPoint = $manifest.entryPoint
            }

            [pscustomobject]@{
                Name = $_name
                Version = $_version
                Description = $_description
                Author = $_author
                Path = $folder.FullName
                RunPath = (Join-Path $folder.FullName $_entryPoint)
            }
        } else {
            [pscustomobject]@{
                Name = $folder.Name
                Version = 'unknown'
                Description = 'No description'
                Author = 'unknown'
                Path = $folder.FullName
                RunPath = (Join-Path $folder.FullName 'run.ps1')
            }
        }
    }

    return @($mods)
}