# windows-connection-spike-logger

# Connection Spike Logger (PowerShell)

Monitors the number of established TCP connections and logs spikes.
Useful for spotting sudden outbound bursts or misbehaving processes.

## Requirements

- Windows
- PowerShell 5.1 or PowerShell 7+
- `Get-NetTCPConnection` available (modern Windows)

## Usage

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\Connection-Spike-Logger.ps1
Example:

powershell
Copy code
.\Connection-Spike-Logger.ps1 -IntervalSeconds 5 -SpikeDelta 50
Notes
This is a coarse signal. Follow up with a per-process snapshot when you see a spike.
