#!/usr/bin/env bash

set -u

echo "=========================================="
echo "     Incident Response Checklist"
echo "=========================================="

echo
echo "[1] System Information"
hostname
uname -a
uptime

echo
echo "[2] Disk Usage"
df -h

echo
echo "[3] Memory Usage"
free -h 2>/dev/null || vm_stat 2>/dev/null || true

echo
echo "[4] High Resource Processes"
ps aux | sort -nrk 3 | head -n 10

echo
echo "[5] Listening Network Ports"
if command -v ss >/dev/null 2>&1; then
    ss -tuln
elif command -v netstat >/dev/null 2>&1; then
    netstat -an | grep LISTEN
else
    echo "Network inspection tool unavailable."
fi

echo
echo "[6] Failed Services"
if command -v systemctl >/dev/null 2>&1; then
    systemctl --failed --no-legend 2>/dev/null || true
else
    echo "systemd unavailable."
fi

echo
echo "[7] Recent Authentication Events"

if [ -f /var/log/auth.log ]; then
    tail -n 20 /var/log/auth.log
elif [ -f /var/log/secure ]; then
    tail -n 20 /var/log/secure
else
    echo "Authentication log not found."
fi

echo
echo "[8] Recovery Checklist"
echo "- Confirm the incident and affected services"
echo "- Preserve relevant logs and timestamps"
echo "- Identify suspicious processes and connections"
echo "- Check recent configuration or deployment changes"
echo "- Isolate affected systems when necessary"
echo "- Restore from a verified clean backup"
echo "- Validate services after recovery"
echo "- Document the incident and corrective actions"

echo
echo "Checklist completed."
