# PowerShell Console.Beep melody demo
# Uses only [Console]::Beep(frequency, duration)

function N($f, $d) {
    [Console]::Beep($f, $d)
}

function R($d) {
    Start-Sleep -Milliseconds $d
}

# Intro
N 392 400   # G4
N 523 400   # C5
N 659 700   # E5
R 100

N 587 300   # D5
N 523 500   # C5
N 440 700   # A4
R 150

# Main phrase
N 392 300
N 440 300
N 523 500
N 659 700
R 100

N 698 400   # F5
N 659 400
N 587 500
N 523 800
R 200

# Ending
N 392 300
N 523 300
N 659 500
N 784 1000  # G5
