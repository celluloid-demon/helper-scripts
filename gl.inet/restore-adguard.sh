#!/bin/ash

ARCHIVE="/tmp/adguardhome-backup.tar.gz"

# Restore from the archive:
/etc/init.d/adguardhome stop
tar -xzvf "$ARCHIVE" -C /
/etc/init.d/adguardhome start
