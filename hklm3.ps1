function Apply-Common {
    Write-Host "공통 설정 적용 중..."
    $url = "https://docs.google.com/spreadsheets/d/1iC_J3OYWdtBEL-bCIFUoHtESe6uRYTh_-7Lk7zSBOTg/export?format=csv&gid=0"
    $regItems = (Invoke-WebRequest -Uri $url).Content -split "`n" |
                Where-Object {$_ -notmatch "^#"} |
                ConvertFrom-Csv

    foreach ($item in $regItems) {
        try {
            switch ($item.Type.ToLower()) {
                "dword" {
                    New-ItemProperty -Path $item.Path -Name $item.Name -Value ([int]$item.Value) -PropertyType DWord -Force
                }
                "string" {
                    New-ItemProperty -Path $item.Path -Name $item.Name -Value $item.Value -PropertyType String -Force
                }
                "multistring" {
                    $multi = $item.Value -split ";"
                    New-ItemProperty -Path $item.Path -Name $item.Name -Value $multi -PropertyType MultiString -Force
                }
                "binary" {
                    $bin = $item.Value.Split("-") | ForEach-Object { [Convert]::ToByte($_,16) }
                    New-ItemProperty -Path $item.Path -Name $item.Name -Value ([byte[]]$bin) -PropertyType Binary -Force
                }
            }
            Write-Host "적용됨: $($item.Path)\$($item.Name) = $($item.Value) ($($item.Type))"
        }
        catch {
            Write-Host "오류: $($item.Path)\$($item.Name) → $_"
        }
    }
    gpupdate /force
}
    
    # URLBlocklist (1~27)
    $blocklist = @{
        "1"  = "chrome://settings"
        "2"  = "chrome://settings/*"
        "3"  = "chrome://history"
        "4"  = "chrome://history/*"
        "5"  = "chrome://extensions"
        "6"  = "chrome://extensions/*"
        "7"  = "chrome://flags"
        "8"  = "chrome://flags/*"
        "9"  = "chrome://signin-internals"
        "10" = "chrome://signin-internals/*"
        "11" = "chrome://management"
        "12" = "chrome://management/*"
        "13" = "chrome://net-internals"
        "14" = "chrome://net-internals/*"
        "15" = "chrome://chrome-urls"
        "16" = "chrome://chrome-urls/*"
        "17" = "chrome://device-log"
        "18" = "chrome://device-log/*"
        "19" = "chrome://system"
        "20" = "chrome://system/*"
        "21" = "chromewebstore.google.com"
        "22" = "chromewebstore.google.com/*"
        "23" = "ftp://*"
        "24" = "file://*"
        "25" = "data:*"
        "26" = "javascript:*"
        "27" = "filesystem:*"
        # "28" = "chrome://*"
        # "29" = "*"
    }
    foreach ($k in $blocklist.Keys) {
        New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome\URLBlocklist" -Name $k -Value $blocklist[$k] -PropertyType String -Force
    }

    # URLAllowlist (1~18)
    $allowlist = @{
        "1"  = "chrome-untrusted://*"
        "2"  = "chrome-extension://*"
        "3"  = "chrome://newtab/"
        "4"  = "chrome://os-settings/"
        "5"  = "chrome://resources/"
        "6"  = "chrome://theme/"
        "7"  = "chrome://favicon/"
        "8"  = "chrome://user-actions/"
        "9"  = "chrome://version/"
        "10" = "chrome://error/"
        "11" = "chrome://welcome/"
        "12" = "chrome://policy/"
        "13" = "apis.google.com"
        "14" = "googleapis.com"
        "15" = "gstatic.com"
        "16" = "colab.research.google.com"
        "17" = "github.com/wogmd1017/class2024"
        "18" = "githubassets.com"
    }
    foreach ($k in $allowlist.Keys) {
        New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome\URLAllowlist" -Name $k -Value $allowlist[$k] -PropertyType String -Force
    }

    Disable-WindowsOptionalFeature -Online -FeatureName Internet-Explorer-Optional-amd64 -NoRestart

    # moviemk.exe
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111111}" -Name "ItemData" -Value "C:\Program Files (x86)\Windows Live\Photo Gallery\moviemk.exe" -PropertyType String -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111111}" -Name "SaferFlags" -Value 0 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111111}" -Name "Level" -Value 0 -PropertyType DWord -Force
    # mspaint.exe
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111112}" -Name "ItemData" -Value "%SystemRoot%\System32\mspaint.exe" -PropertyType String -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111112}" -Name "SaferFlags" -Value 0 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111112}" -Name "Level" -Value 0 -PropertyType DWord -Force
    # Microsoft.Photos.exe
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111113}" -Name "ItemData" -Value "%ProgramFiles%\WindowsApps\Microsoft.Windows.Photos_*\Microsoft.Photos.exe" -PropertyType String -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111113}" -Name "SaferFlags" -Value 0 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111113}" -Name "Level" -Value 0 -PropertyType DWord -Force
    # WindowsCamera.exe
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111114}" -Name "ItemData" -Value "%ProgramFiles%\WindowsApps\Microsoft.WindowsCamera_*\WindowsCamera.exe" -PropertyType String -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111114}" -Name "SaferFlags" -Value 0 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111114}" -Name "Level" -Value 0 -PropertyType DWord -Force
    # Magnify.exe
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111115}" -Name "ItemData" -Value "%SystemRoot%\System32\Magnify.exe" -PropertyType String -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111115}" -Name "SaferFlags" -Value 0 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111115}" -Name "Level" -Value 0 -PropertyType DWord -Force
    # AcroRD32.exe
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111116}" -Name "ItemData" -Value "C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe" -PropertyType String -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111116}" -Name "SaferFlags" -Value 0 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111116}" -Name "Level" -Value 0 -PropertyType DWord -Force
    # Explorer.exe
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111117}" -Name "ItemData" -Value "C:\Windows\explorer.exe" -PropertyType String -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111117}" -Name "SaferFlags" -Value 0 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111117}" -Name "Level" -Value 0 -PropertyType DWord -Force
    
}

function Apply-Choice($num) {
    switch ($num) {
        "1" {
            Apply-Common
            New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome" -Name "NewTabPageLocation" -Value "https://gyeongnam-gm-m.elice.io" -PropertyType String -Force
            # URLBlocklist (28~29)
            $blocklist = @{
                "28"  = "http://*"
                "29"  = "https://*"
            }
            foreach ($k in $blocklist.Keys) {
                New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome\URLBlocklist" -Name $k -Value $blocklist[$k] -PropertyType String -Force
            }
            # URLAllowlist (19~31)
            $allowlist = @{
                "19"  = "*.elice.io/*"
                "20"  = "accounts.elice.io"
                "21"  = "testroom.elice.io"
                "22"  = "api-activity.elice.io"
                "23"  = "api-rest.elice.io"
                "24"  = "api-cms.elice.io"
                "25"  = "api-course.elice.io"
                "26"  = "gyeongnam-gm-m.elice.io"
                "27"  = "googleusercontent.com"
                "28"  = "account.google.com"
                "29"  = "account.google.co.kr"
                "30"  = "accounts.google.com"
                "31"  = "accounts.google.co.kr"
                # "32" = "www.onlinegdb.com"
                }
            foreach ($k in $allowlist.Keys) {
                New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome\URLAllowlist" -Name $k -Value $allowlist[$k] -PropertyType String -Force
                }
            gpupdate /force
            $global:N5 = 1
        }
        "2" {
            Apply-Common
            New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome" -Name "NewTabPageLocation" -Value "https://playentry.org" -PropertyType String -Force
            # URLBlocklist (28~35)
            $blocklist = @{
                "28"  = "http://*"
                "29"  = "https://*"
                "30"  = "http://playentry.org/project"
                "31"  = "https://playentry.org/project"
                "32"  = "http://playentry.org/project/*"
                "33"  = "https://playentry.org/project/*"
                "34"  = "http://playentry.org/project*"
                "35"  = "https://playentry.org/project*"
            }
            foreach ($k in $blocklist.Keys) {
                New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome\URLBlocklist" -Name $k -Value $blocklist[$k] -PropertyType String -Force
            }
            # URLAllowlist (19~27)
            $allowlist = @{
                "19"  = "account.google.com"
                "20"  = "account.google.co.kr"
                "21"  = "accounts.google.com"
                "22"  = "accounts.google.co.kr"
                "23"  = "googleusercontent.com"
                "24"  = "http://playentry.org/"
                "25"  = "https://playentry.org/"
                "26"  = "http://playentry.org/*"
                "27"  = "https://playentry.org/*"
                }
            foreach ($k in $allowlist.Keys) {
                New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome\URLAllowlist" -Name $k -Value $allowlist[$k] -PropertyType String -Force
                }
            gpupdate /force
            $global:N5 = 2
        }
        "3" {
            Apply-Common
            New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome" -Name "NewTabPageLocation" -Value "https://appinventor.mit.edu" -PropertyType String -Force
            # URLBlocklist (28~29)
            $blocklist = @{
                "28"  = "http://*"
                "29"  = "https://*"
            }
            foreach ($k in $blocklist.Keys) {
                New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome\URLBlocklist" -Name $k -Value $blocklist[$k] -PropertyType String -Force
            }
            # URLAllowlist (19~26)
            $allowlist = @{
                "19"  = "account.google.com"
                "20"  = "account.google.co.kr"
                "21"  = "accounts.google.com"
                "22"  = "accounts.google.co.kr"
                "23"  = "googleusercontent.com"
                "24"  = "appinventor.mit.edu"
                "25"  = "mywaycoding.tistory.com"
                "26"  = "mywaycoding.tistory.com/*"
                }
            foreach ($k in $allowlist.Keys) {
                New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome\URLAllowlist" -Name $k -Value $allowlist[$k] -PropertyType String -Force
                }
            gpupdate /force
            $global:N5 = 3
        }
        "4" {
            Apply-Common
            # New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome" -Name "NewTabPageLocation" -Value "https://" -PropertyType String -Force
            # URLBlocklist (28~29)
            $blocklist = @{
                #"28"  = "http://*"
                #"29"  = "https://*"
            }
            foreach ($k in $blocklist.Keys) {
                New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome\URLBlocklist" -Name $k -Value $blocklist[$k] -PropertyType String -Force
            }
            # URLAllowlist (19~23)
            $allowlist = @{
                "19"  = "account.google.com"
                "20"  = "account.google.co.kr"
                "21"  = "accounts.google.com"
                "22"  = "accounts.google.co.kr"
                "23"  = "googleusercontent.com"
                }
            foreach ($k in $allowlist.Keys) {
                New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome\URLAllowlist" -Name $k -Value $allowlist[$k] -PropertyType String -Force
                }
            gpupdate /force
            $global:N5 = 4
        }
        "6" {
            Apply-Common
            Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome" -Name "NewTabPageLocation" -ErrorAction SilentlyContinue
            # URLBlocklist (28~29)
            foreach ($i in 28..29) {
                Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome\URLBlocklist" -Name $i -ErrorAction SilentlyContinue
            }
            # URLAllowlist (19~31)
            foreach ($i in 19..32) {
                Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome\URLAllowlist" -Name $i -ErrorAction SilentlyContinue
                }
            gpupdate /force
            $global:N5 = 6
        }
        "7" {
            Apply-Common
            Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome" -Name "NewTabPageLocation" -ErrorAction SilentlyContinue
            # URLBlocklist (28~35)
            foreach ($i in 28..35) {
                Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome\URLBlocklist" -Name $i -ErrorAction SilentlyContinue
            }
            # URLAllowlist (19~27)
            foreach ($i in 19..27) {
                Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome\URLAllowlist" -Name $i -ErrorAction SilentlyContinue
                }
            gpupdate /force
            $global:N5 = 7
        }
        "8" {
            Apply-Common
            Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome" -Name "NewTabPageLocation" -ErrorAction SilentlyContinue
            # URLBlocklist (28~29)
            foreach ($i in 28..29) {
                Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome\URLBlocklist" -Name $i -ErrorAction SilentlyContinue
            }
            # URLAllowlist (19~31)
            foreach ($i in 19..26) {
                Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome\URLAllowlist" -Name $i -ErrorAction SilentlyContinue
                }
            gpupdate /force
            $global:N5 = 8
        }
        "9" {
            Apply-Common
            Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome" -Name "NewTabPageLocation" -ErrorAction SilentlyContinue
            # URLBlocklist (28~29)
            foreach ($i in 28..29) {
                Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome\URLBlocklist" -Name $i -ErrorAction SilentlyContinue
            }
            # URLAllowlist (19~31)
            foreach ($i in 19..23) {
                Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome\URLAllowlist" -Name $i -ErrorAction SilentlyContinue
                }
            gpupdate /force
            $global:N5 = 9
        }
    }
}

while ($true) {
    Clear-Host
    Write-Host "================================================"
    Write-Host "1. HKLM for elice.io (Python)"
    Write-Host "2. HKLM for Hamster (Entry)"
    Write-Host "3. HKLM for 1g app inventor"
    Write-Host "4. HKLM for 1g AI"
    Write-Host "6. delete 1.(elice.io(Python))"
    Write-Host "7. delete 2.(Hamster(Entry))"
    Write-Host "8. delete 3.(1g app inventor)"
    Write-Host "9. delete 4.(1g AI)"
    Write-Host "================================================"
    $choice = Read-Host "Choose work number"
    Apply-Choice $choice
    Read-Host "Enter를 누르면 메뉴로 돌아갑니다."
}
