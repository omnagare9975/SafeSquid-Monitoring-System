# Monitoring System Resources For Proxy Server

SafeSquid Technical Assignment: Task 1

This project is a terminal-based **System Monitoring Dashboard** built entirely with **Bash scripting**. It provides real-time insights into your system's health, including CPU usage, memory consumption, disk usage, network connections, services, and currently running processes.

---

##  Features

- ✅ Real-time system monitoring
- ✅ View full dashboard or individual components
- ✅ Lightweight with no external dependencies
- ✅ Color-coded, easy-to-read terminal output
- ✅ Press [Q] to quit at any time

---

## Project Structure

```
.
├── monitor.sh            # Main script to run the full or partial dashboard
└── README.md             # Project documentation
```

---

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/SafeSquid-Monitoring-System.git
cd SafeSquid-Monitoring-System
```

### 2. Make the Script Executable

```bash
chmod +x monitor.sh
```

---

## ▶️ Run the Full Dashboard

To launch the **full dashboard**, run:

```bash
./monitor.sh
```

This will display:
- 🔸 CPU Usage
- 🔸 Memory Usage
- 🔸 Disk Usage
- 🔸 Network Monitoring
- 🔸 Top Processes
- 🔸 Services Status

Press **Q** to quit.

---

##  Run Individual Dashboards

You can also run individual sections using flags:

### ✅ CPU Usage
```bash
./monitor.sh -cpu
```

### ✅ Memory Usage
```bash
./monitor.sh -memory
```

### ✅ Disk Usage
```bash
./monitor.sh -disk
```

### ✅ Network Monitoring
```bash
./monitor.sh -network
```

### ✅ Services Status
```bash
./monitor.sh -services
```

Each section refreshes every 2 seconds by default. Press **Q** to exit.

---

## ✅ Requirements

This script uses standard Linux tools:
- `top`
- `free`
- `df`
- `netstat`
- `ps`
- `uptime`
- `systemctl`

Ensure you're running on a Linux system with these commands available.

---

## Example Output

![Screenshot 2025-04-30 165610](https://github.com/user-attachments/assets/f834902d-6c24-4a2e-85d3-d6d00fcd1e97)


---

## 📃 License

This project is licensed under the MIT License.

