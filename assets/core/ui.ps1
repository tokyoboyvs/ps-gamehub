function Set-RobCoTheme {
    param(
        [Parameter(Mandatory)]
        [pscustomobject]$Config
    )
    
    $host.UI.RawUI.BackgroundColor = $Config.theme.background
    $host.UI.RawUI.ForegroundColor = $Config.theme.foreground
    Clear-Host
}


function Show-RobCoBanner {
    param(
        [Parameter(Mandatory)]
        [string]$AppName
    )

    Write-Host '========================================'
    Write-Host '  R O B C O   H U B'
    Write-Host '========================================'
    Write-Host ''
    Write-Host $AppName
    Write-Host ''
}