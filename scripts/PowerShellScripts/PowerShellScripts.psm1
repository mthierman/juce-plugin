# DEVELOPER FUNCTIONS

function Initialize-GhDevShell64 {
  & 'C:\Program Files\Microsoft Visual Studio\2022\Enterprise\Common7\Tools\Launch-VsDevShell.ps1' -HostArch amd64 -Arch amd64 -SkipAutomaticLocation
}
Set-Alias -Name 64bit -Value Initialize-GhDevShell64

function Initialize-GhDevShell32 {
  & 'C:\Program Files\Microsoft Visual Studio\2022\Enterprise\Common7\Tools\Launch-VsDevShell.ps1' -HostArch x86 -Arch x86 -SkipAutomaticLocation
}
Set-Alias -Name 32bit -Value Initialize-GhDevShell32

function Build-GhJucePlugin {
  cmake -B build -G "Ninja"
  cmake --build build --target $args
}
Set-Alias -Name plugin -Value Build-GhJucePlugin

function Build-GhJuceDemo {
  cmake -B build/demo -G "Ninja" -DJUCE_BUILD_EXAMPLES=ON -DJUCE_BUILD_EXTRAS=ON
  cmake --build build/demo --target $args
}
Set-Alias -Name juce-demo -Value Build-GhJuceDemo

function Build-GhJucePluginRelease {
  cmake --preset release
  cmake --build --preset release
}
Set-Alias -Name release -Value Build-GhJucePluginRelease

function Build-GhJucePluginDebug {
  cmake --preset debug
  cmake --build --preset debug
}
Set-Alias -Name debug -Value Build-GhJucePluginDebug

# UTILITY FUNCTIONS

function Add-GhShortcut ($Target, $Path) {
  New-Item -ItemType SymbolicLink -Path $Path -Target $Target
}
Set-Alias -Name shortcut -Value Add-GhShortcut

function Add-Gh7Zip ($Zip) {
  7z a $Zip $args
}
Set-Alias -Name zip -Value Add-Gh7Zip
