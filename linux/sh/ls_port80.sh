#!/bin/bash

#List IP addresses connected to your server on port 80. This command is useful to detect when your server is under attack, and block those IPs.
netstat -tn 2>/dev/null | grep :80 | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -nr | head