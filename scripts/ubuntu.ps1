function Find-GitFiles {
  git ls-files -v
}
Set-Alias -Name list -Value Find-GitFiles
list
