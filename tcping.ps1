param(
    [Parameter(Mandatory = $true)][string]$Host,
    [Parameter(Mandatory = $true)][int]$Port,
    [int]$Count = 4,
    [int]$TimeoutMs = 1000,
    [int]$IntervalMs = 1000
)

$countValue = [Math]::Max(1, $Count)
$timeoutValue = [Math]::Max(1, $TimeoutMs)
$intervalValue = [Math]::Max(0, $IntervalMs)

Write-Host "TCPing $Host`:$Port with $countValue attempts"

$times = New-Object System.Collections.Generic.List[double]
$failed = 0

for ($i = 1; $i -le $countValue; $i++) {
    $client = New-Object System.Net.Sockets.TcpClient
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    try {
        $task = $client.ConnectAsync($Host, $Port)
        $connected = $task.Wait($timeoutValue)
        if (-not $connected) {
            throw [System.TimeoutException]::new("timeout")
        }
        if (-not $client.Connected) {
            throw [System.Exception]::new("connect failed")
        }
        $stopwatch.Stop()
        $times.Add($stopwatch.Elapsed.TotalMilliseconds)
        Write-Host "Reply from $Host`:$Port time=$([Math]::Round($stopwatch.Elapsed.TotalMilliseconds, 2)) ms"
    } catch {
        $failed += 1
        $message = $_.Exception.Message
        if ([string]::IsNullOrWhiteSpace($message)) {
            $message = $_.Exception.GetType().Name
        }
        Write-Host "Attempt $i: failed ($message)"
    } finally {
        $client.Close()
    }

    if ($i -ne $countValue -and $intervalValue -gt 0) {
        Start-Sleep -Milliseconds $intervalValue
    }
}

Write-Host ""
Write-Host "Statistics"
Write-Host "  Attempts: $countValue"
Write-Host "  Success: $($times.Count)"
Write-Host "  Failed: $failed"

if ($times.Count -gt 0) {
    $min = ($times | Measure-Object -Minimum).Minimum
    $max = ($times | Measure-Object -Maximum).Maximum
    $avg = ($times | Measure-Object -Average).Average
    Write-Host "  Min: $([Math]::Round($min, 2)) ms"
    Write-Host "  Avg: $([Math]::Round($avg, 2)) ms"
    Write-Host "  Max: $([Math]::Round($max, 2)) ms"
}
