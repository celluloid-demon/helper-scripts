#!/bin/ash

# Archive the config and data directory:
tar -czvf /tmp/adguardhome-backup.tar.gz /etc/AdGuardHome/config.yaml /etc/AdGuardHome/data

# (Copy the archive off the router using `scp -O ...` to your workstation or backup target.)
