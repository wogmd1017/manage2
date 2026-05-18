$Servers = "10.65.167.11", "10.65.167.12", "10.65.167.13", "10.65.167.14"
$cred = Get-Credential

Invoke-Command -ComputerName $Servers -Credential $cred -ScriptBlock {
    $path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
	    
    if (!(Test-Path $path)) { 
        New-Item -Path $path -Force | Out-Null 
    }
    
    Set-ItemProperty -Path $path -Name "NoRemoveDRIVEUI" -Value 1 -Type DWord
    
    Get-Process explorer -ErrorAction SilentlyContinue | Stop-Process -Force
    Start-Sleep -Seconds 2
    Start-Process explorer.exe
    
    Write-Host "[$(hostname)] 장치 제거 아이콘 차단 완료!" -ForegroundColor Green
}