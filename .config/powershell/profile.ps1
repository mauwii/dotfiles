Function Test-CommandExists {
    Param ($command)

    $oldPreference = $ErrorActionPreference

    $ErrorActionPreference = ‘stop’

    try { if (Get-Command $command) { RETURN $true } }

    Catch { Write-Debug “$command does not exist”; RETURN $false }

    Finally { $ErrorActionPreference = $oldPreference }

} #end function test-CommandExists

If (Test-CommandExists /opt/homebrew/bin/brew) {
    $(/opt/homebrew/bin/brew shellenv pwsh) | Invoke-Expression # initialize starship prompt
}

If (Test-CommandExists starship) {
    $(starship init powershell) | Invoke-Expression # initialize starship prompt
}
