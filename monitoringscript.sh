#!/bin/bash

# Color definitions
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[36m'
BOLD='\e[1m'
RESET='\e[0m'

# Configuration
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80

# Header
clear
echo -e "${BOLD}${BLUE}==================================${RESET}"
echo -e "${BOLD}${BLUE}   System Health Monitor${RESET}"
echo -e "${BOLD}${BLUE}==================================${RESET}\n"

# Display hostname and date
echo -e "${BOLD}Hostname:${RESET} $(hostname)"
echo -e "${BOLD}Date:${RESET} $(date '+%Y-%m-%d %H:%M:%S')"
echo -e "${BOLD}Uptime:${RESET} $(uptime -p)\n"

# CPU Information
echo -e "${BOLD}${BLUE}--- CPU Usage ---${RESET}"
cpu_usage=$(top -bn1 | awk '/Cpu\(s\)/ {print 100 - $8}')
cpu_int=${cpu_usage%.*}

if [ "$cpu_int" -gt "$CPU_THRESHOLD" ]; then
    echo -e "${RED}⚠ CPU: ${cpu_usage}% (ALERT)${RESET}"
elif [ "$cpu_int" -gt 60 ]; then
    echo -e "${YELLOW}CPU: ${cpu_usage}% (Warning)${RESET}"
else
    echo -e "${GREEN}✓ CPU: ${cpu_usage}%${RESET}"
fi

# Show top 3 CPU processes
echo -e "\nTop 3 CPU processes:"
ps aux --sort=-%cpu | awk 'NR<=4 {printf "  %-10s %5s%%  %s\n", $1, $3, $11}'
echo ""

# Memory Information
echo -e "${BOLD}${BLUE}--- Memory Usage ---${RESET}"
free -h
echo ""
mem_usage=$(free | awk '/Mem/ {printf "%.0f", ($3/$2) * 100}')

if [ "$mem_usage" -gt "$MEMORY_THRESHOLD" ]; then
    echo -e "${RED}⚠ Memory: ${mem_usage}% (ALERT)${RESET}"
elif [ "$mem_usage" -gt 60 ]; then
    echo -e "${YELLOW}Memory: ${mem_usage}% (Warning)${RESET}"
else
    echo -e "${GREEN}✓ Memory: ${mem_usage}%${RESET}"
fi
echo ""

# Disk Usage
echo -e "${BOLD}${BLUE}--- Disk Usage ---${RESET}"
df -h | awk 'NR==1 || /^\// {print}'
echo ""

disk_usage=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
if [ "$disk_usage" -gt "$DISK_THRESHOLD" ]; then
    echo -e "${RED}⚠ Root Disk: ${disk_usage}% (ALERT)${RESET}"
elif [ "$disk_usage" -gt 60 ]; then
    echo -e "${YELLOW}Root Disk: ${disk_usage}% (Warning)${RESET}"
else
    echo -e "${GREEN}✓ Root Disk: ${disk_usage}%${RESET}"
fi
echo ""

# Network Information
echo -e "${BOLD}${BLUE}--- Network Status ---${RESET}"
ip -br addr show | awk '{printf "  %-10s %-15s %s\n", $1, $2, $3}'
echo ""

# Service Checks (customize these services)
echo -e "${BOLD}${BLUE}--- Service Status ---${RESET}"
for service in ssh cron; do
    if systemctl is-active --quiet "$service" 2>/dev/null; then
        echo -e "${GREEN}✓ $service: running${RESET}"
    else
        echo -e "${RED}✗ $service: stopped${RESET}"
    fi
done

echo -e "\n${BOLD}${BLUE}==================================${RESET}"
