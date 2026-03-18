Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$script:RootPath = Split-Path -Parent $MyInvocation.MyCommand.Path

. (Join-Path $script:RootPath 'assets\core\ui.ps1')
. (Join-Path $script:RootPath 'assets\core\loader.ps1')

$configPath = Join-Path $script:RootPath 'config.json'
$config = Get-Content -LiteralPath $configPath -Raw | ConvertFrom-Json

Initialize-RobCoStructure -RootPath $script:RootPath
Set-RobCoTheme -Config $config
Show-RobCoBanner -AppName $config.appName

$modsPath = Join-Path $script:RootPath 'assets\mods'
$mods = @(Get-RobCoMods -ModsPath $modsPath)
Write-Host ('Mods detected : {0}' -f $mods.Count)
Write-Host ''

if ($mods.Count -eq 0) {
    Write-Host 'No modules installed.'
} else {
    foreach ($mod in $mods) {
        Write-Host ('- {0} [{1}]' -f $mod.Name, $mod.Version)
    }
}

Write-Host ''
Read-Host 'Press Enter to exit'
