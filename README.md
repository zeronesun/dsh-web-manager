# DSH Web 服务管理脚本

`dsh-web-manager` 是一个轻量级 Shell 脚本，用于管理 DeepSeek Harness (DSH) Web 服务的完整生命周期（启动、停止、重启、状态查看）。它简化了 DSH 在服务器上的部署和运维，并提供智能 SSH 隧道提示，方便远程访问。

## 特性

- **一键管理** — 通过 `start` / `stop` / `restart` / `status` 子命令管理 DSH 服务
- **自动安装** — 首次运行时若系统未安装 DSH，自动执行 `npm install -g @deepseek-ai/dsh@latest`
- **智能提示** — 启动后自动检测服务器 IP 和用户名，生成 SSH 隧道命令
- **进程管理** — PID 文件精确控制进程，避免重复启动
- **日志管理** — 日志自动写入脚本同目录的 `dsh-web-manager.log`
- **路径友好** — 所有运行时文件与脚本同目录，无需绝对路径，易于迁移

## 前提条件

| 依赖 | 说明 |
|------|------|
| Node.js & npm | 脚本会自动安装 DSH，但需要 npm 可用 |
| Git（可选） | 用于克隆仓库 |
| SSH 客户端 | 远程访问 DSH Web 界面时需要 |

## 快速开始

```bash
# 1. 克隆仓库
git clone https://github.com/zeronesun/dsh-web-manager.git
cd dsh-web-manager

# 2. 赋予执行权限
chmod +x scripts/dsh-web-manager.sh

# 3. 启动服务
./scripts/dsh-web-manager.sh start
```

## 命令参考

| 命令 | 功能 |
|------|------|
| `./scripts/dsh-web-manager.sh start` | 启动 DSH Web 服务（未安装时自动安装） |
| `./scripts/dsh-web-manager.sh stop` | 停止服务 |
| `./scripts/dsh-web-manager.sh restart` | 重启服务 |
| `./scripts/dsh-web-manager.sh status` | 查看运行状态及 SSH 隧道命令 |
| `./scripts/dsh-web-manager.sh version` | 查看 dsh 版本（未安装时自动安装） |

## 运行演示

```bash
$ ./scripts/dsh-web-manager.sh start
✅ 检测到 dsh 版本: 0.1.0-rc.6
✅ DSH Web 服务已启动（PID: 1299448）
📄 日志文件: /home/user/dsh-web-manager/dsh-web-manager.log
🌐 访问地址: http://localhost:3080（需配合 SSH 隧道）

🔗 在您的本地电脑（客户端）上执行以下命令，建立 SSH 隧道：
   ssh -N -L 3080:localhost:3080 user1@192.168.2.168
（隧道建立后，在本地电脑浏览器访问 http://localhost:3080 即可）
```

```bash
$ ./scripts/dsh-web-manager.sh status
✅ DSH Web 服务正在运行（PID: 1299448）
📄 日志文件: /home/user/dsh-web-manager/dsh-web-manager.log
🌐 访问地址: http://localhost:3080（需配合 SSH 隧道）
🔗 在您的本地电脑上执行: ssh -N -L 3080:localhost:3080 user1@192.168.2.168
```

```bash
$ ./scripts/dsh-web-manager.sh stop
正在停止 DSH Web 服务（PID: 1299448）...
✅ 服务已停止
```

## 远程访问

DSH Web 默认监听 `127.0.0.1:3080`（仅本机可访问）。从本地电脑访问需建立 SSH 隧道：

```bash
ssh -N -L 3080:localhost:3080 <用户名>@<服务器IP>
```

隧道建立后，本地浏览器打开 `http://localhost:3080` 即可。

> 脚本启动时会自动生成完整的隧道命令，直接复制执行即可。

## 运行时文件

| 文件 | 说明 |
|------|------|
| `scripts/dsh-web-manager.sh` | 主管理脚本 |
| `dsh-web-manager.log` | 服务运行日志（脚本同目录自动生成） |
| `dsh-web-manager.pid` | 进程 PID 文件（脚本同目录自动生成） |

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