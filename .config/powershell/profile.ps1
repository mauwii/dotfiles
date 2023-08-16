Function Test-CommandExists {
    Param (
        [Parameter(Mandatory)]
        [string]$command
    )
    $oldPreference = $ErrorActionPreference
    $ErrorActionPreference = 'Stop'
    try { if (Get-Command $command) { RETURN $true } }
    Catch { Write-Debug “$command does not exist”; RETURN $false }
    Finally { $ErrorActionPreference = $oldPreference }
}

Function Uninstall-OldModules {
    Param (
        [string]$Scope = 'CurrentUser'
    )
    Get-InstalledModule | ForEach-Object {
        $CurrentVersion = $PSItem.Version
        Get-InstalledModule -Name $PSItem.Name -AllVersions | `
            Where-Object -Property Version -LT -Value $CurrentVersion
    } | Uninstall-Module -Verbose
}

If (Test-CommandExists /opt/homebrew/bin/brew) {
    $(/opt/homebrew/bin/brew shellenv pwsh) | `
        Invoke-Expression # load brew shellenv
}

If (Test-CommandExists starship) {
    $(starship init powershell) | `
        Invoke-Expression # initialize starship prompt
}
