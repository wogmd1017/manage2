@{
    Elice = @{
        NewTabPage = "https://boonpo-m.elice.io"
        Allowlist  = @(
            "accounts.elice.io/"
            "accounts.elice.io/accounts*"
            "accounts.elice.io/?continue_to=*"
            "testroom.elice.io"
            "api-activity.elice.io"
            "api-rest.elice.io"
            "api-cms.elice.io"
            "api-course.elice.io"
            "boonpo-m.elice.io"
            "googleusercontent.com"
            "colab.research.google.com"
            "ssl.gstatic.com"
            "ssl.gstatic.com/*"
            "www.gstatic.com"
            "www.gstatic.com/*"
            "apis.google.com"
            "apis.google.com/*"
            "fonts.googleapis.com"
            "fonts.googleapis.com/*"
            "fonts.gstatic.com"
            "fonts.gstatic.com/*"
            "ogs.google.com"
            "ogs.google.com/*"
            "codelove.kr"
            "www.codelove.kr"
        )
        Blocklist  = @(
            "http://*"
            "https://*"
            "accounts.elice.io/members"
            "accounts.elice.io/members*"
            "accounts.elice.io/members/"
            "accounts.elice.io/members/*"
            "accounts.elice.io:443/members"
            "accounts.elice.io:443/members*"
            "accounts.elice.io:443/members/"
            "accounts.elice.io:443/members/*"
            "https://accounts.elice.io/members"
            "https://accounts.elice.io/members*"
            "https://accounts.elice.io/members/"
            "https://accounts.elice.io/members/*"
            "*/members/*"
        )
    }

    Entry = @{
        NewTabPage = $null
        Allowlist  = @(
            "account.google.com"
            "account.google.co.kr"
            "accounts.google.com"
            "accounts.google.co.kr"
            "googleusercontent.com"
            "http://playentry.org/"
            "https://playentry.org/"
        )
        Blocklist  = @(
            "http://*"
            "https://*"
            "http://playentry.org/project"
            "https://playentry.org/project"
            "http://playentry.org/project/*"
            "https://playentry.org/project/*"
            "http://playentry.org/project*"
            "https://playentry.org/project*"
        )
    }

    MakeCode = @{
        NewTabPage = $null
        Allowlist  = @(
            "account.google.com"
            "account.google.co.kr"
            "accounts.google.com"
            "accounts.google.co.kr"
            "googleusercontent.com"
            "makecode.microbit.org"
            "http://makecode.microbit.org"
            "https://makecode.microbit.org"
            "http://makecode.microbit.org/*"
            "https://makecode.microbit.org/*"
        )
        Blocklist  = @(
            "http://*"
            "https://*"
        )
    }

    AppInventor = @{
        NewTabPage = "https://appinventor.mit.edu"
        Allowlist  = @(
            "account.google.com"
            "account.google.co.kr"
            "accounts.google.com"
            "accounts.google.co.kr"
            "googleusercontent.com"
            "appinventor.mit.edu"
            "mywaycoding.tistory.com"
            "mywaycoding.tistory.com/*"
        )
        Blocklist  = @(
            "http://*"
            "https://*"
        )
    }

    Classroom = @{
        NewTabPage = $null
        Allowlist  = @(
            "account.google.com"
            "account.google.co.kr"
            "accounts.google.com"
            "accounts.google.co.kr"
            "googleusercontent.com"
            "classroom.google.com"
            "classroom.google.com/*"
            "ssl.gstatic.com"
            "ssl.gstatic.com/*"
            "www.gstatic.com"
            "www.gstatic.com/*"
            "apis.google.com"
            "apis.google.com/*"
            "fonts.googleapis.com"
            "fonts.googleapis.com/*"
            "fonts.gstatic.com"
            "fonts.gstatic.com/*"
            "ogs.google.com"
            "ogs.google.com/*"
            "https://docs.google.com/forms/"
            "https://docs.google.com/accounts/"
            "edu.google.com"
            "myaccount.google.com"
        )
        Blocklist  = @(
            "http://*"
            "https://*"
            "https://myaccount.google.com/address/"
        )
    }
}
