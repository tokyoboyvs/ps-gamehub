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
    Write-Host ''
    Read-Host 'Press Enter to exit'
    return
}

for ($i = 0; $i -lt $mods.Count; $i++) {
    $index = $i + 1
    $mod = $mods[$i]
    Write-Host ('[{0}] {1} [{2}]' -f $index, $mod.Name, $mod.Version)
}

Write-Host ''
$selection = Read-Host 'Select a module number'
$selectedIndex = 0

if (-not [int]::TryParse($selection, [ref]$selectedIndex)) {
    Write-Host ''
    Write-Host 'Invalid selection.'
    Read-Host 'Press Enter to exit'
    return
}

if ($selectedIndex -lt 1 -or $selectedIndex -gt $mods.Count) {
    Write-Host ''
    Write-Host 'Selection out of range.'
    Read-Host 'Press Enter to exit'
    return
}

$selectedMod = $mods[$selectedIndex - 1]

if (-not (Test-Path -LiteralPath $selectedMod.RunPath)) {
    Write-Host ''
    Write-Host 'Module launcher not found.'
    Read-Host 'Press Enter to exit'
    return
}

& $selectedMod.RunPath
