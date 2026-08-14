# DSH Web 服务管理脚本

这是一个便捷的 Shell 脚本，用于管理 DeepSeek Harness (DSH) Web 服务的完整生命周期（启动、停止、重启、状态查看）。它旨在简化 DSH 的部署和运维。

## 特性

*   **一键管理**: 通过 `start`, `stop`, `restart`, `status` 等子命令轻松管理 DSH 服务。
*   **自动安装**: 首次运行时，若系统未安装 DSH，脚本会自动执行 `npm install -g @deepseek-ai/dsh@latest` 进行安装。
*   **智能提示**: 启动成功后，会自动检测并提示你在本地电脑上建立 SSH 隧道所需的完整命令（`ssh -N -L 3080:localhost:3080 ...`）。
*   **进程管理**: 使用 PID 文件精确控制进程，避免重复启动，并提供友好的状态反馈。

## 前提条件

*   **Node.js 与 npm**: 用于安装和管理 DSH。
*   **Git**: 用于克隆仓库（如需）。
*   **SSH 客户端**: 如果你打算从远程访问 DSH Web 界面。

## 安装与使用

### 1. 获取脚本

你可以直接下载脚本文件，或通过 Git 克隆整个仓库：

```bash
git clone https://github.com/[你的用户名]/[仓库名].git
cd [仓库名]
