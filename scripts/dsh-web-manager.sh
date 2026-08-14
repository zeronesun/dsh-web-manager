#!/bin/bash

# DSH Web 服务管理脚本（路径使用当前目录）
# 用法: ./scripts/dsh-web-manager.sh {start|stop|restart|status|version}

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LOG_FILE="$SCRIPT_DIR/dsh-web-manager.log"
PID_FILE="$SCRIPT_DIR/dsh-web-manager.pid"

# 获取本机 IPv4 地址（优先使用默认路由源IP）
get_ip() {
    # 方法1：从默认路由获取源IP（最准确）
    local ip=$(ip route get 1 2>/dev/null | grep -oP 'src \K\S+')
    if [ -n "$ip" ]; then
        echo "$ip"
        return
    fi
    # 方法2：从所有非回环IP中取第一个
    ip=$(hostname -I 2>/dev/null | awk '{for(i=1;i<=NF;i++) if($i!="127.0.0.1") {print $i; exit}}')
    if [ -n "$ip" ]; then
        echo "$ip"
        return
    fi
    echo "无法自动获取IP，请手动指定"
}

# 检查 dsh 是否可用，若未安装则自动安装
check_dsh() {
    if command -v dsh &> /dev/null; then
        local version=$(dsh --version 2>/dev/null | head -1)
        echo "✅ 检测到 dsh 版本: $version"
        return 0
    else
        echo "⚠️  未检测到 dsh，正在尝试自动安装（npm install -g @deepseek-ai/dsh@latest）..."
        if ! command -v npm &> /dev/null; then
            echo "❌ 错误: npm 未找到，请先安装 Node.js 和 npm。"
            return 1
        fi
        npm install -g @deepseek-ai/dsh@latest
        if [ $? -ne 0 ]; then
            echo "❌ 安装失败，请手动执行: npm install -g @deepseek-ai/dsh@latest"
            return 1
        fi
        if command -v dsh &> /dev/null; then
            local version=$(dsh --version 2>/dev/null | head -1)
            echo "✅ 安装成功，dsh 版本: $version"
            return 0
        else
            echo "❌ 安装后仍无法找到 dsh，请检查 npm 全局 bin 是否在 PATH 中。"
            return 1
        fi
    fi
}

# 检查进程是否在运行
is_running() {
    if [ -f "$PID_FILE" ]; then
        pid=$(cat "$PID_FILE")
        if ps -p "$pid" > /dev/null 2>&1; then
            return 0
        else
            rm -f "$PID_FILE"
            return 1
        fi
    else
        pgrep -f "dsh web" > /dev/null 2>&1
        return $?
    fi
}

# 启动服务
start() {
    if ! check_dsh; then
        return 1
    fi

    if is_running; then
        echo "DSH Web 服务已在运行中（PID: $(cat $PID_FILE 2>/dev/null || pgrep -f 'dsh web')）"
        return 1
    fi

    pkill -f "dsh web" 2>/dev/null

    nohup stdbuf -oL -eL dsh web > "$LOG_FILE" 2>&1 &
    local pid=$!
    echo $pid > "$PID_FILE"

    sleep 1
    if is_running; then
        echo "✅ DSH Web 服务已启动（PID: $pid）"
        echo "📄 日志文件: $LOG_FILE"
        echo "🌐 访问地址: http://localhost:3080（需配合 SSH 隧道）"

        local user=$(whoami)
        local ip=$(get_ip)
        if [ "$ip" != "无法自动获取IP，请手动指定" ]; then
            echo ""
            echo "🔗 在您的本地电脑（客户端）上执行以下命令，建立 SSH 隧道："
            echo "   ssh -N -L 13080:localhost:3080 $user@$ip"
            echo "（隧道建立后，在本地电脑浏览器访问 http://localhost:13080 即可）"
        else
            echo ""
            echo "⚠️  无法自动获取IP，请在客户端手动执行："
            echo "   ssh -N -L 13080:localhost:3080 <用户名>@<本机IP>"
        fi
    else
        echo "❌ 启动失败，请检查日志: $LOG_FILE"
        rm -f "$PID_FILE"
        return 1
    fi
}

# 停止服务
stop() {
    if is_running; then
        local pid=$(cat "$PID_FILE" 2>/dev/null || pgrep -f "dsh web")
        echo "正在停止 DSH Web 服务（PID: $pid）..."
        kill "$pid" 2>/dev/null
        sleep 2
        if is_running; then
            kill -9 "$pid" 2>/dev/null
            echo "强制终止完成"
        fi
        rm -f "$PID_FILE"
        echo "✅ 服务已停止"
    else
        echo "DSH Web 服务未运行"
        rm -f "$PID_FILE"
    fi
}

# 重启服务
restart() {
    stop
    sleep 1
    start
}

# 查看状态
status() {
    if is_running; then
        local pid=$(cat "$PID_FILE" 2>/dev/null || pgrep -f "dsh web")
        echo "✅ DSH Web 服务正在运行（PID: $pid）"
        echo "📄 日志文件: $LOG_FILE"
        echo "🌐 访问地址: http://localhost:3080（需配合 SSH 隧道）"
        local user=$(whoami)
        local ip=$(get_ip)
        if [ "$ip" != "无法自动获取IP，请手动指定" ]; then
            echo "🔗 在您的本地电脑上执行: ssh -N -L 13080:localhost:3080 $user@$ip"
        fi
    else
        echo "DSH Web 服务未运行"
    fi
}

# 显示版本信息
version() {
    check_dsh
}

# 主逻辑
case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        restart
        ;;
    status)
        status
        ;;
    version)
        version
        ;;
    *)
        echo "用法: $0 {start|stop|restart|status|version}"
        exit 1
        ;;
esac

exit 0