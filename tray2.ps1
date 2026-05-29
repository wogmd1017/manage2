$S = "10.65.167.11", "10.65.167.12", "10.65.167.13", "10.65.167.14"
$user = "manager"
$secpasswd = Read-Host -Prompt "$user, Enter Password." -AsSecureString
$cred = New-Object System.Management.Automation.PSCredential($user, $secpasswd)

Invoke-Command -ComputerName $S -Credential $cred -ScriptBlock {
    $path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
    
    if (!(Test-Path $path)) { 
        New-Item -Path $path -Force | Out-Null 
    }

    Set-ItemProperty -Path $path -Name "NoRemoveDRIVEUI" -Value 1 -Type DWord

    Get-Process explorer -ErrorAction SilentlyContinue | Stop-Process -Force
    Start-Sleep -Seconds 2
    Start-Process explorer.exe
    
    Write-Host "[$(hostname)] Tary Icon Blocked!" -ForegroundColor Green
}