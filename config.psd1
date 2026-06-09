@{
    # Servers
    Servers = @(
        "10.65.167.11"
        "10.65.167.12"
        "10.65.167.13"
        "10.65.167.14"
    )
    User = "manager"

    # Students (01-40)
    Students = @(
        "01","02","03","04","05","06","07","08","09","10"
        "11","12","13","14","15","16","17","18","19","20"
        "21","22","23","24","25","26","27","28","29","30"
        "31","32","33","34","35","36","37","38","39","40"
    )
    StudentsPerServer = 10

    # Kiosk
    KioskUrl   = "https://boonpo-m.elice.io"
    ChromePath = @(
        "C:\Program Files\Google\Chrome\Application\chrome.exe"
        "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
    )

    # Paths
    DataPath   = "C:\Users\manager\Desktop\data"
    PsExecPath = "C:\Users\manager\Desktop\data\PsExec.exe"
    LockFile   = "C:\Users\manager\Desktop\data\loop.lock"

    # History tools
    BhvPath    = "C:\Users\manager\Desktop\data\browsinghistoryview.exe"
    RclonePath = "C:\Users\manager\Desktop\data\rclone.exe"
    RcloneConf = "C:\Users\manager\Desktop\data\rclone.conf"

    # Class periods
    Periods = @{
        P1    = "0945"
        P2    = "1040"
        P3    = "1135"
        P4    = "1230"
        Lunch = "1330"
        P5    = "1415"
        P6    = "1510"
        P7    = "1605"
    }
}
