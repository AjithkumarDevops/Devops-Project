#!/bin/bash
USAGE=$(df -h / | awk 'NR==2{print $5}' | sed 's/%//')

if [ $USAGE -gt 80 ]; then
    echo "Warning: Disk usage is above 80% (Current: $USAGE%)"
else
    echo "Disk usage is normal (Current: $USAGE%)"
fi
