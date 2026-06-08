#!/bin/bash
# Usage: ./list_remote_tags.sh <image_name>
# Example: ./list_remote_tags.sh library/nginx

IMAGE=$1

# Handle official images (e.g., "nginx" becomes "library/nginx")
if [[ "$IMAGE" != *"/"* ]]; then
    IMAGE="library/$IMAGE"
fi

# 1. Get an authentication token
TOKEN=$(curl -s "https://auth.docker.io/token?service=registry.docker.io&scope=repository:${IMAGE}:pull" | jq -r .token)

# 2. Fetch and list all tags
curl -s -H "Authorization: Bearer $TOKEN" "https://registry-1.docker.io/v2/${IMAGE}/tags/list" | jq -r '.tags[]' | sort -V
