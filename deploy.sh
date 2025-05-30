#!/bin/bash
set -e

ENV_FILE=${1:-.deploy.env}
source "$ENV_FILE"

SERVICE_FILE="/tmp/${WEBAPP_SERVICE_NAME}.service"
envsubst < webapp.service.template > "$SERVICE_FILE"

sudo cp "$SERVICE_FILE" /etc/systemd/system/${WEBAPP_SERVICE_NAME}.service
sudo systemctl daemon-reload
sudo systemctl enable --now ${WEBAPP_SERVICE_NAME}.service

