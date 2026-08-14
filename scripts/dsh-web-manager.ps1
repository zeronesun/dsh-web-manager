<#
.SYNOPSIS
    DSH Web 服务管理工具 (Windows 本地)
.DESCRIPTION
    管理本地安装的 DeepSeek Harness Web 服务，支持 start/stop/restart/status/version。
    假设 dsh 已通过 npm 全局安装，并已加入 PATH。
.PARAMETER Command
    子命令: start, stop, restart, status, version
.EXAMPLE
    .\dsh-web-manager.ps1 start
.EXAMPLE
    .\dsh-web-manager.ps1 status
#>

param(
    [Parameter(Position=0)]
    [ValidateSet('start','stop','restart','status','version')]
    [string]$Command = 'status'
)

# ---------- 配置 ----------
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$LogFile = Join-Path $ScriptDir "dsh-web-manager.log"
$PidFile = Join-Path $ScriptDir "dsh-web-manager.pid"
$DshCmd = "dsh"

# ---------- 辅助函数 ----------
function Test-DshInstalled {
    $cmd = Get-Command $DshCmd -ErrorAction SilentlyContinue
    return $cmd -ne $null
}

function Get-DshVersion {
    if (-not (Test-DshInstalled)) { return $null }
    $version = & $DshCmd --version 2>$null | Select-Object -First 1
    return $version.Trim()
}

function Test-DshRunning {
    if (Test-Path $PidFile) {
        $pidVal = Get-Content $PidFile -Raw
        if ($pidVal -match '^\d+$') {
            try {
                $proc = Get-Process -Id ([int]$pidVal) -ErrorAction Stop
                return $true
            } catch {
                Remove-Item $PidFile -Force
            }
        }
    }
    # 后备：通过 WMI 查找 node 进程
    try {
        $procs = Get-CimInstance Win32_Process -Filter "Name='node.exe'" -ErrorAction Stop |
            Where-Object { $_.CommandLine -like "*dsh*" -and $_.CommandLine -like "*web*" }
        return $procs -ne $null
    } catch {
        return $false
    }
}

function Get-DshPid {
    if (Test-Path $PidFile) {
        $pidVal = Get-Content $PidFile -Raw
        if ($pidVal -match '^\d+$') { return $pidVal }
    }
    try {
        $procs = Get-CimInstance Win32_Process -Filter "Name='node.exe'" -ErrorAction Stop |
            Where-Object { $_.CommandLine -like "*dsh*" -and $_.CommandLine -like "*web*" }
        if ($procs) { return $procs[0].ProcessId }
    } catch {}
    return $null
}

# ---------- 核心命令 ----------
function Start-Dsh {
    if (-not (Test-DshInstalled)) {
        Write-Host "❌ 未找到 dsh 命令，请先安装: npm install -g @deepseek-ai/dsh" -ForegroundColor Red
        return
    }
    $ver = Get-DshVersion
    Write-Host "✅ 检测到 dsh 版本: $ver" -ForegroundColor Green

    if (Test-DshRunning) {
        $runningPid = Get-DshPid
        Write-Host "DSH Web 服务已在运行中 (PID: $runningPid)" -ForegroundColor Yellow
        return
    }

    # 杀死可能残留的进程
    try {
        $oldProcs = Get-CimInstance Win32_Process -Filter "Name='node.exe'" -ErrorAction Stop |
            Where-Object { $_.CommandLine -like "*dsh*" -and $_.CommandLine -like "*web*" }
        if ($oldProcs) {
            $oldProcs | ForEach-Object { Stop-Process -Id $_.ProcessId -Force }
            Start-Sleep -Seconds 1
        }
    } catch {}

    # 清空日志
    "" | Out-File -FilePath $LogFile -Encoding ascii

    # 启动 DSH（直接启动 node 进程，可获取 PID）
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = "cmd.exe"
    $psi.Arguments = "/c `"$DshCmd`" web"
    $psi.UseShellExecute = $false
    $psi.CreateNoWindow = $true
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $process = [System.Diagnostics.Process]::Start($psi)
    $dshPid = $process.Id
    Start-Sleep -Seconds 3

    # 检测是否成功启动（检查日志是否有输出 或 进程是否存活）
    $logContent = Get-Content $LogFile -Raw -ErrorAction SilentlyContinue
    if ($process.HasExited -eq $false -or ($logContent -and $logContent -match "http://")) {
        $dshPid | Out-File -FilePath $PidFile -Encoding ascii
        Write-Host "✅ DSH Web 服务已启动 (PID: $dshPid)" -ForegroundColor Green
        Write-Host "📄 日志文件: $LogFile" -ForegroundColor Cyan
        Write-Host "🌐 访问地址: http://localhost:3080" -ForegroundColor Cyan
        Write-Host "👉 在 Windows 浏览器中直接打开上述地址即可使用。" -ForegroundColor Gray
    } else {
        Write-Host "❌ 启动失败，请检查日志: $LogFile" -ForegroundColor Red
        if (Test-Path $PidFile) { Remove-Item $PidFile -Force }
    }
}

function Stop-Dsh {
    if (-not (Test-DshRunning)) {
        Write-Host "DSH Web 服务未运行" -ForegroundColor Yellow
        if (Test-Path $PidFile) { Remove-Item $PidFile -Force }
        return
    }
    $runningPid = Get-DshPid
    Write-Host "正在停止 DSH Web 服务 (PID: $runningPid)..." -ForegroundColor Cyan
    try {
        Stop-Process -Id $runningPid -Force
        Start-Sleep -Seconds 2
    } catch {
        Write-Host "进程可能已退出" -ForegroundColor Gray
    }
    if (Test-Path $PidFile) { Remove-Item $PidFile -Force }
    Write-Host "✅ 服务已停止" -ForegroundColor Green
}

function Restart-Dsh {
    Stop-Dsh
    Start-Sleep -Seconds 2
    Start-Dsh
}

function Status-Dsh {
    if (Test-DshRunning) {
        $runningPid = Get-DshPid
        Write-Host "✅ DSH Web 服务正在运行 (PID: $runningPid)" -ForegroundColor Green
        Write-Host "📄 日志文件: $LogFile" -ForegroundColor Cyan
        Write-Host "🌐 访问地址: http://localhost:3080" -ForegroundColor Cyan
    } else {
        Write-Host "DSH Web 服务未运行" -ForegroundColor Yellow
    }
}

function Version-Dsh {
    if (-not (Test-DshInstalled)) {
        Write-Host "❌ dsh 未安装，请执行: npm install -g @deepseek-ai/dsh" -ForegroundColor Red
        return
    }
    $ver = Get-DshVersion
    Write-Host "✅ dsh 版本: $ver" -ForegroundColor Green
}

# ---------- 主逻辑 ----------
switch ($Command) {
    "start"   { Start-Dsh }
    "stop"    { Stop-Dsh }
    "restart" { Restart-Dsh }
    "status"  { Status-Dsh }
    "version" { Version-Dsh }
    default   { 
        Write-Host "用法: .\dsh-web-manager.ps1 {start|stop|restart|status|version}" -ForegroundColor Cyan
    }
}