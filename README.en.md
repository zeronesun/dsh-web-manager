# DSH Web Service Management Script

`dsh-web-manager` is a lightweight Shell script for managing the full lifecycle (start, stop, restart, status check) of the DeepSeek Harness (DSH) Web service. It is designed to simplify DSH deployment and operations on servers, with intelligent SSH tunnel prompts for convenient remote access.

## Features

- **One‑click Management**: Easily manage the DSH service via sub‑commands like `start`, `stop`, `restart`, and `status`.
- **Auto‑Installation**: On first run, if DSH is not installed on the system, the script automatically executes `npm install -g @deepseek-ai/dsh@latest` to complete the installation.
- **Smart Prompts**: After a successful start, it automatically detects the server's IP and username, and generates a complete SSH tunnel command for you to establish a connection from your local machine.
- **Process Management**: Uses a PID file to precisely control the process, prevents duplicate startups, and provides clear status feedback.
- **Log Management**: Service logs are automatically written to `dsh-web.log` in the same directory as the script, making troubleshooting easy.
- **Path‑Friendly**: All runtime files (logs, PID) are located in the same directory as the script — no absolute paths required, making it easy to migrate.

## Prerequisites

- **Node.js and npm**: Required for installing and managing DSH (the script installs DSH automatically, but npm must be available).
- **Git** (optional): For cloning the repository.
- **SSH Client**: Required if you need to access the DSH Web UI from a remote machine.

## Installation & Usage

### 1. Get the Script

You can clone the repository via Git, or download the script file directly.

```bash
git clone https://github.com/zeronesun/dsh-web-manager.git
cd dsh-web-manager
```

Alternatively, download `dsh-web.sh` and place it in your target directory.

### 2. Make It Executable

```bash
chmod +x dsh-web.sh
```

### 3. Available Commands

| Command | Description |
|---------|-------------|
| `./dsh-web.sh start` | Start the DSH Web service (auto‑installs DSH if missing) |
| `./dsh-web.sh stop` | Stop the service |
| `./dsh-web.sh restart` | Restart the service |
| `./dsh-web.sh status` | Check service status and view the SSH tunnel command |
| `./dsh-web.sh version` | Show the dsh version (auto‑installs DSH if missing) |

**Examples**

```bash
# Start the service
./dsh-web.sh start
```

```bash
# Check status
./dsh-web.sh status
```

```bash
# Stop the service
./dsh-web.sh stop
```

### 4. Running Demo

```bash
# View help
$ ./dsh-web.sh
Usage: ./dsh-web.sh {start|stop|restart|status|version}

# Check service status (first run, service not started)
$ ./dsh-web.sh status
DSH Web service is not running

# Start DSH Web service (auto‑detects dsh version and prompts SSH tunnel command)
$ ./dsh-web.sh start
✅ Detected dsh version: 0.1.0-rc.6
✅ DSH Web service started (PID: 1299448)
📄 Log file: /home/suntest/daily-shell/dsh-web.log
🌐 Access URL: http://localhost:3080 (requires SSH tunnel)

🔗 Run the following command on your local machine to establish the SSH tunnel:
   ssh -N -L 3080:localhost:3080 user1@192.168.2.168
(After the tunnel is established, open http://localhost:3080 in your local browser)

# Stop the service
$ ./dsh-web.sh stop
Stopping DSH Web service (PID: 1299448)...
✅ Service stopped
```

### 5. Remote Access

After starting, DSH listens on `127.0.0.1:3080` (local access only). To access it from your local machine, run the SSH tunnel command prompted by the script in **your local machine's terminal**, for example:

```bash
ssh -N -L 3080:localhost:3080 your-username@your-server-ip
```

Once the tunnel is established, open `http://localhost:3080` in your local browser to use the DSH Web UI.

## Files & Logs

| File | Description |
|------|-------------|
| `dsh-web.sh` | Main management script |
| `dsh-web.log` | DSH service runtime logs, auto‑generated in the script's directory |
| `dsh-web.pid` | Stores the DSH process PID for service management |

## Contributing

Contributions are welcome! You can participate by:

1. Fork this repository.
2. Create your feature branch (`git checkout -b feature/AmazingFeature`).
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`).
4. Push to the branch (`git push origin feature/AmazingFeature`).
5. Open a Pull Request.

Please ensure your code style is consistent with the existing codebase and update relevant documentation.

## License

This project is licensed under the [MIT License](LICENSE). You are free to use, modify, distribute, and commercialize this project, provided that you retain the original copyright notice.

## Acknowledgements

Thanks to the [DeepSeek](https://www.deepseek.com/) team for developing the [DSH](https://github.com/deepseek-ai/dsh) project, which provides the core service for this script.
