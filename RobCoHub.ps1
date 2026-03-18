Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$script:RootPath = Split-Path -Parent $MyInvocation.MyCommand.Path

. (Join-Path $script:RootPath 'assets\core\ui.ps1')
. (Join-Path $script:RootPath 'assets\core\loader.ps1')

$configPath = Join-Path $script:RootPath 'config.json'
$config = Get-Content -LiteralPath $configPath -Raw | ConvertFrom-Json

Initialize-RobCoStructure -RootPath $script:RootPath

while ($true) {
    Set-RobCoTheme -Config $config
    Show-RobCoBanner -AppName $config.appName

    $modsPath = Join-Path $script:RootPath 'assets\mods'
    $mods = @(Get-RobCoMods -ModsPath $modsPath)

    Write-Host ('Mods detected : {0}' -f $mods.Count)
    Write-Host ''

    if ($mods.Count -eq 0) {
        Write-Host 'No modules installed.'
        Write-Host ''
        $emptyAction = Read-Host 'Press Enter to refresh or type Q to quit'

        if ($emptyAction -eq 'q' -or $emptyAction -eq 'Q') {
            break
        }

        continue
    }

    for ($i = 0; $i -lt $mods.Count; $i++) {
        $index = $i + 1
        $mod = $mods[$i]
        Write-Host ('[{0}] {1} [{2}]' -f $index, $mod.Name, $mod.Version)
        Write-Host ('    {0}' -f $mod.Description)
        Write-Host ('    by {0}' -f $mod.Author)
    }

    Write-Host ''
    Write-Host '[Q] Quit'
    Write-Host ''

    $selection = Read-Host 'Select a module number'
    $selectedIndex = 0

    if ($selection -eq 'q' -or $selection -eq 'Q') {
        break
    }

    if (-not [int]::TryParse($selection, [ref]$selectedIndex)) {
        Write-Host ''
        Read-Host 'Invalid selection. Press Enter to continue'
        continue
    }

    if ($selectedIndex -lt 1 -or $selectedIndex -gt $mods.Count) {
        Write-Host ''
        Read-Host 'Selection out of range. Press Enter to continue'
        continue
    }

    $selectedMod = $mods[$selectedIndex - 1]

    if (-not (Test-Path -LiteralPath $selectedMod.RunPath)) {
        Write-Host ''
        Read-Host 'Module launcher not found. Press Enter to continue'
        continue
    }

    & $selectedMod.RunPath
}
