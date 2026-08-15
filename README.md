# DSH Web 服务管理脚本

`dsh-web-manager` 是一套轻量级管理脚本，用于管理 DeepSeek Harness (DSH) Web 服务的完整生命周期（启动、停止、重启、状态查看）。它简化了 DSH 在服务器和本地环境中的部署和运维。提供两套脚本，分别适配 Linux/Mac 服务器（Shell）和 Windows 本地（PowerShell）场景。

## 特性

- **一键管理** — 通过 `start` / `stop` / `restart` / `status` / `version` 子命令管理 DSH 服务
- **自动安装** — Shell 脚本首次运行时若系统未安装 DSH，自动执行 `npm install -g @deepseek-ai/dsh@latest`
- **智能提示** — Shell 脚本启动后自动检测服务器 IP 和用户名，生成 SSH 隧道命令
- **进程管理** — PID 文件精确控制进程，避免重复启动
- **日志管理** — 日志自动写入脚本同目录的 `dsh-web-manager.log`
- **路径友好** — 所有运行时文件与脚本同目录，无需绝对路径，易于迁移
- **跨平台** — 同时支持 Linux/Mac（Shell）和 Windows（PowerShell）

## 前提条件

| 依赖 | 说明 |
|------|------|
| Node.js & npm | Shell 脚本会自动安装 DSH，但需要 npm 可用；PowerShell 脚本需手动安装 DSH |
| Git（可选） | 用于克隆仓库 |
| SSH 客户端 | 远程访问 DSH Web 界面时需要（仅 Linux/Mac 服务器场景） |

## 快速开始

### Linux / Mac（服务器端）

```bash
# 1. 克隆仓库
git clone https://github.com/zeronesun/dsh-web-manager.git
cd dsh-web-manager

# 2. 赋予执行权限
chmod +x scripts/dsh-web-manager.sh

# 3. 启动服务
./scripts/dsh-web-manager.sh start
```

### Windows（本地）

```powershell
# 1. 克隆仓库
git clone https://github.com/zeronesun/dsh-web-manager.git
cd dsh-web-manager

# 2. 确保 dsh 已全局安装
npm install -g @deepseek-ai/dsh

# 3. 启动服务（若执行策略受限，追加 -ExecutionPolicy Bypass）
& ".\scripts\dsh-web-manager.ps1" start
# 或
powershell -ExecutionPolicy Bypass -File ".\scripts\dsh-web-manager.ps1" start
```

> **注意**：Windows PowerShell 5.1 默认无法正确解析无 BOM 的 UTF-8 文件。如果脚本中的中文字符导致解析错误，请确保脚本文件以 **UTF-8 with BOM** 编码保存。仓库中的脚本已包含 BOM，如遇问题可重新拉取。

## 命令参考

### Shell 脚本（Linux / Mac）

| 命令 | 功能 |
|------|------|
| `./scripts/dsh-web-manager.sh start` | 启动 DSH Web 服务（未安装时自动安装） |
| `./scripts/dsh-web-manager.sh stop` | 停止服务 |
| `./scripts/dsh-web-manager.sh restart` | 重启服务 |
| `./scripts/dsh-web-manager.sh status` | 查看运行状态及 SSH 隧道命令 |
| `./scripts/dsh-web-manager.sh version` | 查看 dsh 版本（未安装时自动安装） |

### PowerShell 脚本（Windows）

| 命令 | 功能 |
|------|------|
| `& ".\scripts\dsh-web-manager.ps1" start` | 启动 DSH Web 服务 |
| `& ".\scripts\dsh-web-manager.ps1" stop` | 停止服务 |
| `& ".\scripts\dsh-web-manager.ps1" restart` | 重启服务 |
| `& ".\scripts\dsh-web-manager.ps1" status` | 查看运行状态 |
| `& ".\scripts\dsh-web-manager.ps1" version` | 查看 dsh 版本 |

## 运行演示

### Shell 脚本（Linux / Mac）

```bash
$ ./scripts/dsh-web-manager.sh start
✅ 检测到 dsh 版本: 0.1.0-rc.6
✅ DSH Web 服务已启动（PID: 1299448）
📄 日志文件: /home/user/dsh-web-manager/dsh-web-manager.log
🌐 访问地址: http://localhost:3080（需配合 SSH 隧道）

🔗 在您的本地电脑（客户端）上执行以下命令，建立 SSH 隧道：
   ssh -N -L 13080:localhost:3080 user1@192.168.2.168
（隧道建立后，在本地电脑浏览器访问 http://localhost:13080 即可）
```

```bash
$ ./scripts/dsh-web-manager.sh status
✅ DSH Web 服务正在运行（PID: 1299448）
📄 日志文件: /home/user/dsh-web-manager/dsh-web-manager.log
🌐 访问地址: http://localhost:3080（需配合 SSH 隧道）
🔗 在您的本地电脑上执行: ssh -N -L 13080:localhost:3080 user1@192.168.2.168
```

```bash
$ ./scripts/dsh-web-manager.sh stop
正在停止 DSH Web 服务（PID: 1299448）...
✅ 服务已停止
```

### PowerShell 脚本（Windows）

```powershell
PS> & ".\scripts\dsh-web-manager.ps1" start
✅ 检测到 dsh 版本: 0.1.0-rc.6
✅ DSH Web 服务已启动 (PID: 12345)
📄 日志文件: D:\projects\dsh-web-manager\scripts\dsh-web-manager.log
🌐 访问地址: http://localhost:3080
👉 在 Windows 浏览器中直接打开上述地址即可使用。
```

```powershell
PS> & ".\scripts\dsh-web-manager.ps1" status
✅ DSH Web 服务正在运行 (PID: 12345)
📄 日志文件: D:\projects\dsh-web-manager\scripts\dsh-web-manager.log
🌐 访问地址: http://localhost:3080
```

```powershell
PS> & ".\scripts\dsh-web-manager.ps1" stop
正在停止 DSH Web 服务 (PID: 12345)...
✅ 服务已停止
```

## 远程访问

### Linux / Mac 服务器

DSH Web 默认监听 `127.0.0.1:3080`（仅本机可访问）。从本地电脑访问需建立 SSH 隧道：

```bash
ssh -N -L 13080:localhost:3080 <用户名>@<服务器IP>
```

隧道建立后，本地浏览器打开 `http://localhost:13080` 即可。

> Shell 脚本启动时会自动生成完整的隧道命令，直接复制执行即可。

### Windows 本地

DSH Web 默认监听 `127.0.0.1:3080`，直接在本地浏览器打开 `http://localhost:3080` 即可使用，无需额外配置。

## 运行时文件

| 文件 | 说明 |
|------|------|
| `scripts/dsh-web-manager.sh` | Shell 管理脚本（Linux / Mac） |
| `scripts/dsh-web-manager.ps1` | PowerShell 管理脚本（Windows） |
| `scripts/dsh-web-manager.log` | 服务运行日志（脚本同目录自动生成） |
| `scripts/dsh-web-manager.pid` | 进程 PID 文件（脚本同目录自动生成） |

## 常见问题

### Windows PowerShell 解析错误：字符串缺少终止符

**现象**：运行 `.ps1` 脚本时出现类似以下错误：

```
字符串缺少终止符: "。
语句块或类型定义中缺少右"}"。
```

**原因**：Windows PowerShell 5.1 默认使用系统 ANSI 编码（如 GBK）读取 `.ps1` 文件，无法正确解析 UTF-8 无 BOM 文件中的中文字符，导致字符串引号边界被破坏。

**解决**：将脚本重新保存为 **UTF-8 with BOM** 格式。可使用以下命令：

```powershell
$content = Get-Content ".\scripts\dsh-web-manager.ps1" -Raw -Encoding UTF8
[System.IO.File]::WriteAllText("$PWD\scripts\dsh-web-manager.ps1", $content, (New-Object System.Text.UTF8Encoding $true))
```

> 仓库中的脚本已包含 BOM，从仓库直接克隆后不会出现此问题。

### PowerShell 执行策略限制

**现象**：运行脚本时提示"无法加载文件，因为在此系统上禁止运行脚本"。

**解决**：使用 `-ExecutionPolicy Bypass` 参数运行：

```powershell
powershell -ExecutionPolicy Bypass -File ".\scripts\dsh-web-manager.ps1" start
```

或为当前用户永久设置（需管理员权限）：

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## 贡献

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交修改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送分支 (`git push origin feature/AmazingFeature`)
5. 发起 Pull Request

## 许可证

[MIT License](LICENSE)

## 致谢

感谢 [DeepSeek](https://www.deepseek.com/) 团队开发的 [DSH](https://github.com/deepseek-ai/dsh) 项目，为本脚本提供了核心服务。