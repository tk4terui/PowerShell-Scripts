# Close-SSHPortForwardings.ps1
# PowerShell 上で起動した SSH のポートフォワーディング (-L / -R) と
# 背景ジョブ (ssh コマンド) を検出し、停止します。

$ErrorActionPreference = 'Stop'

# ── 1. SSH ポートフォワーディングプロセスの取得 ──
$sshProcs = Get-CimInstance Win32_Process -Filter "Name='ssh.exe'" |
    Where-Object {
        $_.CommandLine -match '\s-[LR]\s' -and
        (Get-Process -Id $_.ParentProcessId -ErrorAction SilentlyContinue).Name -match '^(powershell|pwsh)$'
    }

if ($sshProcs) {
    Write-Host "検出された SSH ポートフォワーディングプロセス:" -ForegroundColor Cyan
    $sshProcs | ForEach-Object { Write-Host "PID: $($_.ProcessId)  CMD: $($_.CommandLine)" }

    $sshProcs | ForEach-Object {
        try {
            Stop-Process -Id $_.ProcessId -Force -ErrorAction Stop
            Write-Host "停止: PID $($_.ProcessId)" -ForegroundColor Green
        } catch {
            Write-Warning "停止失敗: PID $($_.ProcessId) – $_"
        }
    }
} else {
    Write-Host "SSH ポートフォワーディングプロセスは見つかりませんでした。" -ForegroundColor Green
}

# ── 2. 背景ジョブで走っている ssh コマンドの取得 ──
$sshJobs = Get-Job |
    Where-Object {
        $_.State -eq 'Running' -and
        ($_.PSBeginTime -or $true) -and   # ジョブが実行中であることだけ保証
        ($_.Command -match 'ssh')
    }

if ($sshJobs) {
    Write-Host "検出された SSH バックグラウンドジョブ:" -ForegroundColor Cyan
    $sshJobs | ForEach-Object { Write-Host "Job ID: $($_.Id)  Name: $($_.Name)  Cmd: $($_.Command)" }

    $sshJobs | ForEach-Object {
        try {
            Stop-Job -Id $_.Id -Force -ErrorAction Stop
            Write-Host "停止: Job $($_.Id)" -ForegroundColor Green
        } catch {
            Write-Warning "停止失敗: Job $($_.Id) – $_"
        }
    }
} else {
    Write-Host "SSH バックグラウンドジョブは見つかりませんでした。" -ForegroundColor Green
}

Write-Host "SSH のポートフォワーディングとバックグラウンドジョブのチェックが完了しました。" -ForegroundColor Yellow
