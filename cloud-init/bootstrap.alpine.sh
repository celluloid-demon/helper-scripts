#!/bin/bash

# Exit on error
set -e

apk -U upgrade
apk add fastfetch htop tree
