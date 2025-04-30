#!/bin/bash

# Color codes
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
CYAN="\033[36m"
BOLD="\033[1m"
RESET="\033[0m"

# Refresh rate
INTERVAL=2

# Function to display CPU usage
cpu_usage() {
    echo -e "${CYAN}+---------------- CPU Usage ----------------+${RESET}"
    CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
    LOAD=$(uptime | awk -F'load average:' '{print $2}')
    echo -e "CPU Usage : ${YELLOW}${CPU}%${RESET} | Load Avg :${YELLOW}${LOAD}${RESET}"
    echo ""
}

# Function to display Memory usage
memory_usage() {
    echo -e "${CYAN}+---------------- Memory Usage --------------+${RESET}"
    read total used <<<$(free -m | awk 'NR==2{print $2, $3}')
    mem_percent=$((used * 100 / total))
    echo -e "Memory Used : ${YELLOW}${used}Mi / ${total}Mi (${mem_percent}%)${RESET}"

    read swaptotal swapused <<<$(free -m | awk 'NR==3{print $2, $3}')
    echo -e "Swap Used   : ${YELLOW}${swapused}Mi / ${swaptotal}Mi${RESET}"
    echo ""
}

# Function to display Disk usage
disk_usage() {
    echo -e "${CYAN}+---------------- Disk Usage ----------------+${RESET}"
    disk_percent=$(df / | awk 'END{print $5}')
    echo -e "Disk Usage : ${YELLOW}${disk_percent}${RESET}"

    df -h | awk '$5+0 > 80 {print $6, $5}' | while read mount usage; do
        echo -e "${RED}Warning: High usage on${RESET} ${mount} - ${usage}"
    done
    echo ""
}

# Function to display Top Processes
top_processes() {
    echo -e "${CYAN}+------------ Top Processes (CPU & Mem) -------------+${RESET}"
    printf "${BOLD}%-5s %-20s %-10s %-10s${RESET}\n" "PID" "Process" "CPU(%)" "Mem(%)"
    ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 6
    echo ""
}

# Function for Network monitoring
network_monitoring() {
    echo -e "${CYAN}+-------------- Network Monitoring ---------------+${RESET}"
    ACTIVE_CONN=$(netstat -an 2>/dev/null | grep ESTABLISHED | wc -l)
    PACKET_DROP=$(netstat -s 2>/dev/null | grep -i "segments retransmited" | awk '{print $1}')
    RX=$(cat /sys/class/net/eth0/statistics/rx_bytes 2>/dev/null || echo 0)
    TX=$(cat /sys/class/net/eth0/statistics/tx_bytes 2>/dev/null || echo 0)
    RX_MB=$(echo "scale=2; $RX/1024/1024" | bc)
    TX_MB=$(echo "scale=2; $TX/1024/1024" | bc)
    echo -e "Active Connections : ${YELLOW}${ACTIVE_CONN}${RESET} | Packet Drops : ${YELLOW}${PACKET_DROP}${RESET}"
    echo -e "Data In : ${YELLOW}${RX_MB}MB${RESET} | Data Out : ${YELLOW}${TX_MB}MB${RESET}"
    echo ""
}

# Function to check Service status
service_status() {
    echo -e "${CYAN}+---------------- Services Status ----------------+${RESET}"
    for service in sshd nginx iptables; do
        if systemctl list-unit-files | grep -qw "${service}.service"; then
            systemctl is-active --quiet $service && STATUS="${GREEN}RUNNING${RESET}" || STATUS="${RED}STOPPED${RESET}"
            echo -e "$service : [$STATUS]"
        else
            echo -e "$service : ${RED}Not Installed${RESET}"
        fi
    done
    echo ""
}

# Full dashboard
full_dashboard() {
    clear
    echo -e "${BOLD}${CYAN}+-----------------------------------------------+${RESET}"
    echo -e "${BOLD}${CYAN}|           SYSTEM MONITOR DASHBOARD            |${RESET}"
    echo -e "${BOLD}${CYAN}+-----------------------------------------------+${RESET}"
    echo ""

    cpu_usage
    memory_usage
    disk_usage
    top_processes
    network_monitoring
    service_status

    echo -e "${BOLD}Press [Q] to exit | Refreshing every ${INTERVAL}s...${RESET}"
}

# Partial dashboard
case "$1" in
    -cpu)
        while true; do
            clear
            cpu_usage
            echo -e "${BOLD}Press [Q] to exit | Refreshing every ${INTERVAL}s...${RESET}"
            read -t $INTERVAL -n 1 key
            [[ $key = "q" || $key = "Q" ]] && exit
        done
        ;;
    -memory)
        while true; do
            clear
            memory_usage
            echo -e "${BOLD}Press [Q] to exit | Refreshing every ${INTERVAL}s...${RESET}"
            read -t $INTERVAL -n 1 key
            [[ $key = "q" || $key = "Q" ]] && exit
        done
        ;;
    -disk)
        while true; do
            clear
            disk_usage
            echo -e "${BOLD}Press [Q] to exit | Refreshing every ${INTERVAL}s...${RESET}"
            read -t $INTERVAL -n 1 key
            [[ $key = "q" || $key = "Q" ]] && exit
        done
        ;;
    -network)
        while true; do
            clear
            network_monitoring
            echo -e "${BOLD}Press [Q] to exit | Refreshing every ${INTERVAL}s...${RESET}"
            read -t $INTERVAL -n 1 key
            [[ $key = "q" || $key = "Q" ]] && exit
        done
        ;;
    -services)
        while true; do
            clear
            service_status
            echo -e "${BOLD}Press [Q] to exit | Refreshing every ${INTERVAL}s...${RESET}"
            read -t $INTERVAL -n 1 key
            [[ $key = "q" || $key = "Q" ]] && exit
        done
        ;;
    *)
        while true; do
            full_dashboard
            read -t $INTERVAL -n 1 key
            [[ $key = "q" || $key = "Q" ]] && exit
        done
        ;;
esac

