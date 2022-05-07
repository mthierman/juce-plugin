# DEVELOPER FUNCTIONS

function Initialize-DevShell64 {
  & 'C:\Program Files\Microsoft Visual Studio\2022\Enterprise\Common7\Tools\Launch-VsDevShell.ps1' -HostArch amd64 -Arch amd64 -SkipAutomaticLocation
}
Set-Alias -Name 64bit -Value Initialize-DevShell64

function Initialize-DevShell32 {
  & 'C:\Program Files\Microsoft Visual Studio\2022\Enterprise\Common7\Tools\Launch-VsDevShell.ps1' -HostArch x86 -Arch x86 -SkipAutomaticLocation
}
Set-Alias -Name 32bit -Value Initialize-DevShell32

function Build-JucePlugin {
  cmake -B build -G "Ninja"
  cmake --build build --target $args
}
Set-Alias -Name plugin -Value Build-JucePlugin

function Build-Release {
  cmake --preset release
  cmake --build --preset release
}
Set-Alias -Name plugin-release -Value Build-Release

function Build-Debug {
  cmake --preset debug
  cmake --build --preset debug
}
Set-Alias -Name plugin-debug -Value Build-Debug

function Build-JuceDemo {
  cmake -B build/demo -G "Ninja" -DJUCE_BUILD_EXAMPLES=ON -DJUCE_BUILD_EXTRAS=ON
  cmake --build build/demo --target $args
}
Set-Alias -Name juce-demo -Value Build-JuceDemo

# UTILITY FUNCTIONS

function Find-GitFiles {
  git ls-files -v
}
Set-Alias -Name list-files -Value Find-GitFiles
  
function Add-Symlink ($Path, $Target) {
  New-Item -ItemType SymbolicLink -Path $Path -Target $Target
}
Set-Alias -Name shortcut -Value Add-Symlink
