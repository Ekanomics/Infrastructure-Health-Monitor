# Infrastructure Health Monitor

A lightweight bash script for monitoring server health metrics (CPU, memory, disk, services).

## Features
- Real-time CPU, memory, and disk usage monitoring
- Color-coded output (green/yellow/red based on thresholds)
- Service health checks
- Automated deployment via GitHub Actions
- Slack/email notifications for threshold breaches (temporarily disabled)
(Install mail utility first if you need email alerts and enable monitoringscript.sh notifications part for slack alerts enabling
sudo apt install -y mailutils)

## Installation

### Manual Setup
\`\`\`bash
git clone https://github.com/USERNAME/Infrastructure-Health-Monitor.git
cd Infrastructure-Health-Monitor
chmod +x monitoringscript.sh
./monitoringscript.sh
\`\`\`

### Automated Scheduling
\`\`\`bash
crontab -e
# Add: */15 * * * * /path/to/monitoringscript.sh >> /var/log/monitoringscript.log
\`\`\`

## Configuration
Edit thresholds at the top of `monitoringscript.sh`:
\`\`\`bash
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80
\`\`\`

## CI/CD Pipeline
Automated deployment to DigitalOcean via GitHub Actions on push to main branch.

## Monitoring
View logs: `tail -f /var/log/monitoringscript.log`

## Technologies
- Bash scripting
- GitHub Actions
- DigitalOcean Droplet (server)
- Cron scheduling
- SSH deployment

## Author
Erkin - Cloud / DevOps Engineer