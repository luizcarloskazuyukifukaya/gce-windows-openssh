New-EventLog -LogName Application -Source "OpenSSH Installation"
Write-EventLog -LogName Application -Source "OpenSSH Installation" -EntryType Information -EventID 0 -Message "Starting install script"

$hasOpenSSHD = Get-Service "sshd"
if (-not($hasOpenSSHD)) {
    Write-EventLog -LogName Application -Source "OpenSSH Installation" -EntryType Information -EventID 1 -Message "Installing Choco..."

    $packageURL = 'https://github.com/PowerShell/Win32-OpenSSH/releases/download/v8.0.0.0p1-Beta/OpenSSH-Win64.zip'
    $sourceFile = 'C:\ProgramData\OpenSSH\OpenSSH-Win64.zip'

    Write-EventLog -LogName Application -Source "OpenSSH Installation" -EntryType Information -EventID 2 -Message "Downloading $packageURL to $sourceFile"
    $dir = 'C:\ProgramData\OpenSSH'
    if(!(Test-Path -Path $dir )) {
      New-Item -ItemType directory -Path $dir
    }
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $packageURL -OutFile $sourceFile
    #Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-WebRequest -Uri $packageURL -OutFile $sourceFile
    #Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadFile($packageURL, $sourceFile))
    $destFolder = 'C:Program Files\OpenSSH-Win64'

    Write-EventLog -LogName Application -Source "OpenSSH Installation" -EntryType Information -EventID 3 -Message "Expanding zip file to $destFolder"

    Expand-Archive -LiteralPath $sourceFile -DestinationPath $destFolder

    Write-EventLog -LogName Application -Source "OpenSSH Installation" -EntryType Information -EventID 4 -Message "Starting OpenSSHD install script: $installOpenSSHDScript"

    $installOpenSSHDScript = 'C:Program Files\OpenSSH-Win64\install-sshd.ps1'
    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ($installOpenSSHDScript)

    Write-EventLog -LogName Application -Source "OpenSSH Installation" -EntryType Information -EventID 5 -Message "Completed OpenSSHD install script: $installOpenSSHDScript"

    Write-EventLog -LogName Application -Source "OpenSSH Installation" -EntryType Information -EventID 6 -Message "Setting SSHD services to automatic.."

    Set-Service SSHD -StartupType Automatic

    Write-EventLog -LogName Application -Source "OpenSSH Installation" -EntryType Information -EventID 7 -Message "Setting Firewall ingress to accept SSH connection."

    New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22

    Write-EventLog -LogName Application -Source "OpenSSH Installation" -EntryType Information -EventID 8 -Message "Installation Completed."

} else {
    Write-EventLog -LogName Application -Source "OpenSSH Installation" -EntryType Information -EventID 9 -Message "OpenSSH is already installed"
}
