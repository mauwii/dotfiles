# $arch = $(arch)
# if ($arch -ceq "arm64") {
#     $brewpath = "/opt/homebrew/bin/brew"
# }
# elseif ($arch -ceq "x86_64") {
#     $brewpath = "/usr/local/bin/brew"
# }

$(/opt/homebrew/bin/brew shellenv pwsh) | Invoke-Expression
