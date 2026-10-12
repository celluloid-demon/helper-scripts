#!/bin/bash

# Exit on error
set -e

apk -U upgrade
apk add borgbackup fastfetch htop tree
