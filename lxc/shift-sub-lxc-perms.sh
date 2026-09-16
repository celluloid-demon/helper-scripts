#!/usr/bin/env bash

# @ai-generated: This script was generated with the assistance of AI.

# Exit immediately if a command fails or an unset variable is used
set -euo pipefail

# Define the standard unprivileged LXC offset (Default: 100000)
OFFSET=100000

# Ensure the script is run with root/sudo privileges
if [[ $EUID -ne 0 ]]; then
    echo "ERROR: This script must be run as root or with sudo." >&2
    exit 1
fi

# Ensure a target directory argument is provided
if [[ $# -ne 1 ]]; then
    echo "Usage: $0 /path/to/lxc/rootfs_or_folder" >&2
    exit 1
fi

TARGET_PATH="$1"

# Verify the target path exists and is a directory
if [[ ! -d "$TARGET_PATH" ]]; then
    echo "ERROR: Path '$TARGET_PATH' does not exist or is not a directory." >&2
    exit 1
fi

echo "Starting recursive LXC ownership reversal under: $TARGET_PATH"
echo "Removing an offset of -$OFFSET from all shifted UIDs and GIDs..."

# Use find to cleanly safely iterate through every file, symlink, and directory
# using null-delimiters to prevent issues with spaces in filenames.
find "$TARGET_PATH" -print0 | while IFS= read -r -d '' item; do
    # Skip broken symlinks or missing files mid-run
    [[ -e "$item" || -L "$item" ]] || continue

    # Fetch the current numerical UID and GID of the item
    current_uid=$(stat -c "%u" "$item")
    current_gid=$(stat -c "%g" "$item")

    # Only remove the offset if the ID is currently within or above the offset boundary
    if [[ "$current_uid" -ge "$OFFSET" ]]; then
        new_uid=$((current_uid - OFFSET))
    else
        new_uid=$current_uid
    fi

    if [[ "$current_gid" -ge "$OFFSET" ]]; then
        new_gid=$((current_gid - OFFSET))
    else
        new_gid=$current_gid
    fi

    # Only apply the chown if a shift actually needs to happen
    if [[ "$current_uid" != "$new_uid" || "$current_gid" != "$new_gid" ]]; then
        # The -h flag ensures we change the symlink itself, not the target file
        chown -h "$new_uid:$new_gid" "$item"
    fi
done

echo "SUCCESS: Ownership reversal complete."
