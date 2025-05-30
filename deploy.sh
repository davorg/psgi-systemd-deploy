#!/bin/bash
set -e

TEMPLATE_DIR="$(dirname "$(realpath "$0")")"
ENV_FILE=".deploy.env"
SERVICE_FILE="/etc/systemd/system"

if [[ "$1" == "--dry-run" ]]; then
  DRY_RUN=true
else
  DRY_RUN=false
fi

# Load env file
if [[ -f "$ENV_FILE" ]]; then 
  echo "Processing '$ENV_FILE'"
  set -a
  # shellcheck source=/dev/null
  . "$ENV_FILE"
  set +a
else
  echo "Error: Environment file '$ENV_FILE' not found."
  exit 1
fi

# Default runner
WEBAPP_RUNNER="${WEBAPP_RUNNER:-/usr/bin/starman}"

# Build command
WEBAPP_CMD="$WEBAPP_RUNNER"

if [[ -n "$WEBAPP_WORKER_COUNT" ]]; then
  WEBAPP_CMD+=" --workers=$WEBAPP_WORKER_COUNT"
fi

if [[ -n "$WEBAPP_APP_PORT" ]]; then
  WEBAPP_CMD+=" -l :$WEBAPP_APP_PORT"
fi

if [[ "$WEBAPP_APP_PRELOAD" == "1" ]]; then
  WEBAPP_CMD+=" --preload-app"
fi

WEBAPP_CMD+=" $WEBAPP_WORKDIR/bin/app.psgi"

export WEBAPP_CMD

# Ensure all WEBAPP_* variables are exported for envsubst
for var in $(compgen -v | grep ^WEBAPP_); do
  export "$var"
done

# Render the template
TEMPLATE="$TEMPLATE_DIR/webapp.service.template"
RENDERED_CONTENT=$(envsubst < "$TEMPLATE")

if $DRY_RUN; then
  echo "Dry run mode: rendered service file:"
  echo "------------------------------------"
  echo "$RENDERED_CONTENT"
  echo "------------------------------------"
  echo "No changes made to system."
else
  SERVICE_PATH="$SERVICE_FILE/${WEBAPP_NAME}.service"
  echo "$RENDERED_CONTENT" > "$SERVICE_PATH"
  systemctl daemon-reexec
  systemctl daemon-reload
  systemctl enable "${WEBAPP_NAME}.service"
  systemctl restart "${WEBAPP_NAME}.service"
  echo "Service '${WEBAPP_NAME}' deployed and restarted."
fi

