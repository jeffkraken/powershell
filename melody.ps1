# PowerShell Console.Beep melody demo
# Uses only [Console]::Beep(frequency, duration)

function Note($f, $d) {
    [Console]::Beep($f, $d)
}

function Rest($d) {
    Start-Sleep -Milliseconds $d
}

# Intro
Note 392 400   # G4
Note 523 400   # C5
Note 659 700   # E5
Rest 100

Note 587 300   # D5
Note 523 500   # C5
Note 440 700   # A4
Rest 150

# Main phrase
Note 392 300
Note 440 300
Note 523 500
Note 659 700
Rest 100

Note 698 400   # F5
Note 659 400
Note 587 500
Note 523 800
Rest 200

# Ending
Note 392 300
Note 523 300
Note 659 500
Note 784 1000  # G5

Start-Process powershell.exe -ArgumentList @(
    '-ExecutionPolicy', 'Bypass',
    '-File', "`"$PSCommandPath`"",
    '-Rerun'
)

exit
