$ASIO_SDK_URL="https://www.steinberg.net/asiosdk"
$SDK_DOWNLOAD_FILE="asiosdk.zip"
$LIBS_DIR="libs"
$SDK_DIRNAME="asio"
$SDK_LOCATION="$LIBS_DIR\$SDK_DIRNAME"

function Get-ASIOSDK {
  Write-Output "-- Checking for Steinberg ASIO SDK"
  if (! (Test-Path $SDK_LOCATION)) {
    if (! (Test-Path $SDK_DOWNLOAD_FILE)) {
      Write-Output "-- Downloading $SDK_DOWNLOAD_FILE"
      Invoke-WebRequest -Uri $ASIO_SDK_URL -UseBasicParsing -OutFile $SDK_DOWNLOAD_FILE
    }
    else {
      Write-Output "-- Found $SDK_DOWNLOAD_FILE"
    }
    Write-Output "-- Extracting to $SDK_LOCATION"
    Expand-Archive $SDK_DOWNLOAD_FILE $LIBS_DIR
    Push-Location -Path $LIBS_DIR
    (Get-ChildItem -Filter "$SDK_DIRNAME*")[0] | Rename-Item -NewName { $_.Name -Replace $_.Name, $SDK_DIRNAME }
    Pop-Location
  }
  else {
    Write-Output "-- Steinberg ASIO SDK location: $SDK_LOCATION"
  }
  if ((Test-Path $SDK_DOWNLOAD_FILE)) {
    Remove-Item $SDK_DOWNLOAD_FILE
    Write-Output "-- Cleaning up $SDK_DOWNLOAD_FILE"
  }
  Write-Output "-- The resulting standalone executables are not licensed for distribution"
}
Set-Alias -Name asio -Value Get-ASIOSDK
