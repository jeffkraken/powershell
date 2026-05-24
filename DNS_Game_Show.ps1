Clear-Host

$resolvers = @(
    "1.1.1.1",
    "8.8.8.8"
)

$ips = @(
    "1.2.3.4",
    "8.8.4.4",
    "12.34.56.78"
)

$fqdns = @(
    "facebook.com",
    "example.org",
    "cybergoblin.org",
    "nytimes.com"
)

$scoreboard = @{}

foreach ($resolver in $resolvers) {
    $scoreboard[$resolver] = @{
        Wins = 0
        TotalMs = 0
        Queries = 0
    }
}

Write-Host ""
Write-Host "=========================================" -ForegroundColor Magenta
Write-Host "        DNS GAME SHOW                    " -ForegroundColor Yellow
Write-Host "=========================================" -ForegroundColor Magenta
Write-Host ""

# ==========================
# PTR ROUND
# ==========================

foreach ($ip in $ips) {

    Write-Host ""
    Write-Host "PTR ROUND -> $ip" -ForegroundColor Cyan

    $roundResults = @()

    foreach ($resolver in $resolvers) {

        $sw = [System.Diagnostics.Stopwatch]::StartNew()

        try {

            $result = Resolve-DnsName $ip `
                -Type PTR `
                -Server $resolver `
                -ErrorAction Stop

            $sw.Stop()

            $ms = $sw.ElapsedMilliseconds

            $name = $result.NameHost

            Write-Host "[$resolver] answered in $ms ms -> $name" -ForegroundColor Green

            $roundResults += [PSCustomObject]@{
                Resolver = $resolver
                TimeMs   = $ms
                Success  = $true
            }

            $scoreboard[$resolver].TotalMs += $ms
            $scoreboard[$resolver].Queries += 1
        }
        catch {

            $sw.Stop()

            $ms = $sw.ElapsedMilliseconds

            Write-Host "[$resolver] FAILED in $ms ms" -ForegroundColor Red

            $roundResults += [PSCustomObject]@{
                Resolver = $resolver
                TimeMs   = 999999
                Success  = $false
            }
        }
    }

    $winner = $roundResults |
        Sort-Object TimeMs |
        Select-Object -First 1

    if ($winner.Success) {

        $scoreboard[$winner.Resolver].Wins += 1

        Write-Host ""
        Write-Host " WINNER: $($winner.Resolver)" -ForegroundColor Yellow
    }
}

# ==========================
# MX ROUND
# ==========================

foreach ($fqdn in $fqdns) {

    Write-Host ""
    Write-Host "MX ROUND -> $fqdn" -ForegroundColor Cyan

    $roundResults = @()

    foreach ($resolver in $resolvers) {

        $sw = [System.Diagnostics.Stopwatch]::StartNew()

        try {

            $result = Resolve-DnsName $fqdn `
                -Type MX `
                -Server $resolver `
                -ErrorAction Stop

            $sw.Stop()

            $ms = $sw.ElapsedMilliseconds

            $mx = ($result |
                Sort-Object Preference |
                Select-Object -First 1).NameExchange

            Write-Host "[$resolver] answered in $ms ms -> $mx" -ForegroundColor Green

            $roundResults += [PSCustomObject]@{
                Resolver = $resolver
                TimeMs   = $ms
                Success  = $true
            }

            $scoreboard[$resolver].TotalMs += $ms
            $scoreboard[$resolver].Queries += 1
        }
        catch {

            $sw.Stop()

            $ms = $sw.ElapsedMilliseconds

            Write-Host "[$resolver] FAILED in $ms ms" -ForegroundColor Red

            $roundResults += [PSCustomObject]@{
                Resolver = $resolver
                TimeMs   = 999999
                Success  = $false
            }
        }
    }

    $winner = $roundResults |
        Sort-Object TimeMs |
        Select-Object -First 1

    if ($winner.Success) {

        $scoreboard[$winner.Resolver].Wins += 1

        Write-Host ""
        Write-Host " WINNER: $($winner.Resolver)" -ForegroundColor Yellow
    }
}

# ==========================
# FINAL SCOREBOARD
# ==========================

Write-Host ""
Write-Host "=========================================" -ForegroundColor Magenta
Write-Host "             FINAL SCORES                " -ForegroundColor Yellow
Write-Host "=========================================" -ForegroundColor Magenta
Write-Host ""

$final = foreach ($resolver in $resolvers) {

    $avg = 0

    if ($scoreboard[$resolver].Queries -gt 0) {
        $avg = [math]::Round(
            $scoreboard[$resolver].TotalMs /
            $scoreboard[$resolver].Queries,
            2
        )
    }

    [PSCustomObject]@{
        Resolver  = $resolver
        Wins      = $scoreboard[$resolver].Wins
        AvgMs     = $avg
        Queries   = $scoreboard[$resolver].Queries
    }
}

$final |
    Sort-Object Wins -Descending |
    Format-Table -AutoSize

$champion = $final |
    Sort-Object Wins -Descending |
    Select-Object -First 1

Write-Host ""
Write-Host "DNS CHAMPION: $($champion.Resolver)" -ForegroundColor Yellow
Write-Host ""

Read-Host "Press Enter to exit"
