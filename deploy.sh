#!/bin/bash
set -e

# Resolve the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Default values
ENV_FILE=".deploy.env"
DRY_RUN=false

# Parse arguments
while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=true ;;
    -e|--env) ENV_FILE="$2"; shift ;;
    *) ENV_FILE="$1" ;;  # fallback to legacy single-arg use
  esac
  shift
done

# Load env vars
source "$ENV_FILE"

# Create temporary file
SERVICE_FILE="/tmp/${WEBAPP_SERVICE_NAME}.service"
envsubst < "$SCRIPT_DIR/webapp.service.template" > "$SERVICE_FILE"

if $DRY_RUN; then
  echo "Dry run mode: rendered service file:"
  echo "------------------------------------"
  cat "$SERVICE_FILE"
  echo "------------------------------------"
  echo "No changes made to system."
  exit 0
fi

# Install and start the service
sudo cp "$SERVICE_FILE" "/etc/systemd/system/${WEBAPP_SERVICE_NAME}.service"
sudo systemctl daemon-reload
sudo systemctl enable --now "${WEBAPP_SERVICE_NAME}.service"

