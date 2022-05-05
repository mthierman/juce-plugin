function dev {
  & 'C:\Program Files\Microsoft Visual Studio\2022\Enterprise\Common7\Tools\Launch-VsDevShell.ps1' -HostArch amd64 -Arch amd64 -SkipAutomaticLocation
}

function build {
  cmake --preset build
  cmake --build --preset build
}

function debug {
  cmake --preset debug
  cmake --build --preset debug
}

function symlink ($Path, $Target) {
  New-Item -ItemType SymbolicLink -Path $Path -Target $Target
}

function JUCE {
  & 'C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\Launch-VsDevShell.ps1' -HostArch amd64 -Arch amd64 -SkipAutomaticLocation
  cmake -B build -G "Ninja"
  cmake --build build
}

function JUCEDEMO {
  cmake -B build -G "Ninja" -DJUCE_BUILD_EXAMPLES=ON -DJUCE_BUILD_EXTRAS=ON
  cmake --build build --target DemoRunner
}