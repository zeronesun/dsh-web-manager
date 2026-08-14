# DSH Web 服务管理脚本

`dsh-web-manager` 是一个轻量级的 Shell 脚本，用于管理 DeepSeek Harness (DSH) Web 服务的完整生命周期（启动、停止、重启、状态查看）。它旨在简化 DSH 在服务器上的部署和运维，并提供智能的 SSH 隧道提示，方便远程访问。

## 特性

- **一键管理**: 通过 `start`, `stop`, `restart`, `status` 等子命令轻松管理 DSH 服务
- **自动安装**: 首次运行时，若系统未安装 DSH，脚本会自动执行 `npm install -g @deepseek-ai/dsh@latest` 完成安装
- **智能提示**: 启动成功后，自动检测当前服务器的 IP 和用户名，并生成完整的 SSH 隧道命令，方便你在本地电脑上建立连接
- **进程管理**: 使用 PID 文件精确控制进程，避免重复启动，并提供清晰的状态反馈
- **日志管理**: 服务日志自动写入与脚本同目录的 `dsh-web.log` 文件，便于问题排查
- **路径友好**: 所有运行时文件（日志、PID）均与脚本位于同一目录，无需绝对路径，易于迁移

## 前提条件

- **Node.js 与 npm**: 用于安装和管理 DSH（脚本会自动安装，但需要 npm 可用）
- **Git** (可选): 用于克隆仓库
- **SSH 客户端**: 如果你需要从远程机器访问 DSH Web 界面

## 安装与使用

### 1. 获取脚本

你可以通过 Git 克隆仓库，或直接下载脚本文件。

```bash
git clone https://github.com/your-username/dsh-web-manager.git
cd dsh-web-manager
```

或直接下载 `dsh-web.sh` 并放到你的目标目录。

### 2. 赋予执行权限

```bash
chmod +x dsh-web.sh
```

### 3. 常用命令

| 命令 | 功能 |
|------|------|
| `./dsh-web.sh start` | 启动 DSH Web 服务（若未安装则自动安装） |
| `./dsh-web.sh stop` | 停止服务 |
| `./dsh-web.sh restart` | 重启服务 |
| `./dsh-web.sh status` | 查看服务运行状态及 SSH 隧道命令 |
| `./dsh-web.sh version` | 查看 dsh 版本（若未安装则自动安装） |

**示例**

```bash
# 启动服务
./dsh-web.sh start

# 查看状态
./dsh-web.sh status

# 停止服务
./dsh-web.sh stop
```

### 4. 从远程访问

脚本启动 DSH 后，默认监听在 `127.0.0.1:3080`（只允许本机访问）。要从你的本地电脑访问，请在**本地电脑的终端**中执行脚本启动时提示的 SSH 隧道命令，例如：

```bash
ssh -N -L 3080:localhost:3080 your-username@your-server-ip
```

建立隧道后，在本地浏览器打开 `http://localhost:3080` 即可使用 DSH Web 界面。

## 文件与日志

| 文件 | 说明 |
|------|------|
| `dsh-web.sh` | 主管理脚本 |
| `dsh-web.log` | DSH 服务的运行日志，由脚本自动生成在脚本同级目录 |
| `dsh-web.pid` | 存储 DSH 进程的 PID，用于服务管理 |

## 贡献指南

1. Fork 本仓库
2. 创建你的特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交你的修改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启一个 Pull Request

请确保你的代码风格与现有代码保持一致，并更新相关文档。

## 许可证

本项目采用 [MIT License](LICENSE) 开源协议。你可以自由使用、修改、分发和商用本项目，只需保留原始的版权声明即可。

## 致谢

感谢 [DeepSeek](https://www.deepseek.com/) 团队开发的 [DSH](https://github.com/deepseek-ai/dsh) 项目，为本脚本提供了核心服务。
