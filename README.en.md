# DSH Web Service Management Script

`dsh-web-manager` is a lightweight Shell script for managing the full lifecycle (start, stop, restart, status check) of the DeepSeek Harness (DSH) Web service. It simplifies DSH deployment and operations on servers, with intelligent SSH tunnel prompts for convenient remote access.

## Features

- **One‑click Management** — Manage the DSH service via `start` / `stop` / `restart` / `status` sub‑commands
- **Auto‑Installation** — On first run, if DSH is not installed, automatically executes `npm install -g @deepseek-ai/dsh@latest`
- **Smart Prompts** — After startup, auto‑detects server IP and username, generates SSH tunnel command
- **Process Management** — PID file for precise process control, prevents duplicate startups
- **Log Management** — Logs auto‑written to `dsh-web-manager.log` in the script's directory
- **Path‑Friendly** — All runtime files reside alongside the script — no absolute paths, easy to migrate

## Prerequisites

| Dependency | Description |
|------------|-------------|
| Node.js & npm | The script installs DSH automatically, but npm must be available |
| Git (optional) | For cloning the repository |
| SSH Client | Required for remote access to the DSH Web UI |

## Quick Start

```bash
# 1. Clone the repository
git clone https://github.com/zeronesun/dsh-web-manager.git
cd dsh-web-manager

# 2. Make it executable
chmod +x scripts/dsh-web-manager.sh

# 3. Start the service
./scripts/dsh-web-manager.sh start
```

## Command Reference

| Command | Description |
|---------|-------------|
| `./scripts/dsh-web-manager.sh start` | Start the DSH Web service (auto‑installs DSH if missing) |
| `./scripts/dsh-web-manager.sh stop` | Stop the service |
| `./scripts/dsh-web-manager.sh restart` | Restart the service |
| `./scripts/dsh-web-manager.sh status` | Check service status and view SSH tunnel command |
| `./scripts/dsh-web-manager.sh version` | Show dsh version (auto‑installs DSH if missing) |

## Running Demo

```bash
$ ./scripts/dsh-web-manager.sh start
✅ Detected dsh version: 0.1.0-rc.6
✅ DSH Web service started (PID: 1299448)
📄 Log file: /home/user/dsh-web-manager/dsh-web-manager.log
🌐 Access URL: http://localhost:3080 (requires SSH tunnel)

🔗 Run the following command on your local machine to establish the SSH tunnel:
   ssh -N -L 13080:localhost:3080 user1@192.168.2.168
(After the tunnel is established, open http://localhost:13080 in your local browser)
```

```bash
$ ./scripts/dsh-web-manager.sh status
✅ DSH Web service is running (PID: 1299448)
📄 Log file: /home/user/dsh-web-manager/dsh-web-manager.log
🌐 Access URL: http://localhost:3080 (requires SSH tunnel)
🔗 Run on your local machine: ssh -N -L 13080:localhost:3080 user1@192.168.2.168
```

```bash
$ ./scripts/dsh-web-manager.sh stop
Stopping DSH Web service (PID: 1299448)...
✅ Service stopped
```

## Remote Access

DSH Web listens on `127.0.0.1:3080` (local access only). To access from your local machine, establish an SSH tunnel:

```bash
ssh -N -L 13080:localhost:3080 <username>@<server-ip>
```

Once the tunnel is established, open `http://localhost:13080` in your local browser.

> The script auto‑generates the complete tunnel command on startup — just copy and run it.

## Runtime Files

| File | Description |
|------|-------------|
| `scripts/dsh-web-manager.sh` | Main management script |
| `dsh-web-manager.log` | Service runtime log (auto‑generated alongside the script) |
| `dsh-web-manager.pid` | Process PID file (auto‑generated alongside the script) |

## Contributing

1. Fork this repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

[MIT License](LICENSE)

## Acknowledgements

Thanks to the [DeepSeek](https://www.deepseek.com/) team for developing the [DSH](https://github.com/deepseek-ai/dsh) project, which provides the core service for this script.