#!/bin/bash

# Configuration
LOG_FILE="/var/log/health_monitor.log"
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80

# Function to get CPU usage
get_cpu_usage() {
    top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}'
}

# Function to get memory usage
get_memory_usage() {
    free | awk '/Mem/ {printf("%.1f", ($3/$2) * 100)}'
}

# Function to get disk usage
get_disk_usage() {
    df -h / | awk '/\// {print $(NF-1)}' | sed 's/%//'
}

# Function to check service health
check_service() {
    systemctl status $1 --no-pager | grep "Active" | awk '{print $2}'
}

# Alert function (placeholder for email/Slack)
send_alert() {
    local resource=$1
    local usage=$2
    echo "[ALERT] $(date '+%Y-%m-%d %H:%M:%S') - $resource usage at ${usage}%" | tee -a "$LOG_FILE"
}

# Main monitoring loop
while true; do
    cpu=$(get_cpu_usage)
    memory=$(get_memory_usage)
    disk=$(get_disk_usage)
    
    # Check thresholds
    if (( $(echo "$cpu > $CPU_THRESHOLD" | bc -l) )); then
        send_alert "CPU" "$cpu"
    fi
    
    if (( $(echo "$memory > $MEMORY_THRESHOLD" | bc -l) )); then
        send_alert "Memory" "$memory"
    fi
    
    if [ "$disk" -gt "$DISK_THRESHOLD" ]; then
        send_alert "Disk" "$disk"
    fi
    
    # Display stats
    echo "=== System Health Monitor ==="
    echo "CPU: ${cpu}%"
    echo "Memory: ${memory}%"
    echo "Disk: ${disk}%"
    echo "Last check: $(date)"
    
    sleep 5
done
