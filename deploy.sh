#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ENV_FILE=""
DRY_RUN=false

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --dry-run)
      DRY_RUN=true
      ;;
    -e|--env)
      ENV_FILE="$2"
      shift
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: $0 [--dry-run] [-e|--env <envfile>]"
      exit 1
      ;;
  esac
  shift
done

# Default to .deploy.env in current directory if not set
ENV_FILE="${ENV_FILE:-.deploy.env}"

if [[ -f "$ENV_FILE" ]]; then 
  echo "Processing '$ENV_FILE'"
  source "$ENV_FILE"
else
  echo "Error: Environment file '$ENV_FILE' not found."
  exit 1
fi

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

sudo cp "$SERVICE_FILE" "/etc/systemd/system/${WEBAPP_SERVICE_NAME}.service"
sudo systemctl daemon-reload
sudo systemctl enable --now "${WEBAPP_SERVICE_NAME}.service"

