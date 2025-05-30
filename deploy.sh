#!/bin/bash
set -e

# Resolve the directory of this script (even if called via symlink)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Use first arg as env file or default to .deploy.env
ENV_FILE="${1:-.deploy.env}"
source "$ENV_FILE"

# Render and install the service
SERVICE_FILE="/tmp/${WEBAPP_SERVICE_NAME}.service"
envsubst < "$SCRIPT_DIR/webapp.service.template" > "$SERVICE_FILE"

sudo cp "$SERVICE_FILE" "/etc/systemd/system/${WEBAPP_SERVICE_NAME}.service"
sudo systemctl daemon-reload
sudo systemctl enable --now "${WEBAPP_SERVICE_NAME}.service"

