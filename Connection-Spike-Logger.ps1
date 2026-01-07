# TABARC-Code
param(
  [int]$IntervalSeconds = 5,
  [int]$SpikeDelta = 50,
  [string]$LogPath = "$PSScriptRoot\conn-spikes.log"
)

function Log([string]$msg) {
  $ts = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
  Add-Content -LiteralPath $LogPath -Value "[$ts] $msg" -Encoding UTF8
  Write-Host "[$ts] $msg"
}

$prev = (Get-NetTCPConnection -State Established -ErrorAction SilentlyContinue).Count
Log "Started. Established=$prev Interval=${IntervalSeconds}s SpikeDelta=$SpikeDelta"

while ($true) {
  Start-Sleep -Seconds $IntervalSeconds
  $conns = Get-NetTCPConnection -State Established -ErrorAction SilentlyContinue
  $cur = $conns.Count
  $delta = $cur - $prev

  if ($delta -ge $SpikeDelta) {
    $top = $conns | Group-Object OwningProcess | Sort-Object Count -Descending | Select-Object -First 10
    $summary = ($top | ForEach-Object {
      $pid = [int]$_.Name
      $p = Get-Process -Id $pid -ErrorAction SilentlyContinue
      $name = if ($p) { $p.ProcessName } else { "PID:$pid" }
      "$name($pid)=$($_.Count)"
    }) -join ", "
    Log "Spike: $prev -> $cur (delta=$delta). Top: $summary"
  }

  $prev = $cur
}
