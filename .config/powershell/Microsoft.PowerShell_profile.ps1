$(/opt/homebrew/bin/brew shellenv pwsh) | Invoke-Expression # initialize brew env

$(starship init powershell) | Invoke-Expression # initialize starship prompt
