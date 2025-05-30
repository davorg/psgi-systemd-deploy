# psgi-systemd-deploy

A generic deployment framework for running Perl/PSGI web applications as
`systemd` services.

This repository provides:

- A reusable `systemd` service template
- A simple deploy script
- An example environment configuration file

It’s designed to help you run multiple PSGI-based apps with clean startup,
logging, and automatic boot-time launching — without hardcoding anything per
project.

---

## 🚀 Features

- Automatic `.service` file generation from environment variables
- Autostart on boot with `systemctl enable`
- Centralised logs using `journalctl` or traditional log files
- Easy integration into existing PSGI app deployments

---

## 📦 Usage

1. Clone or download this repository:

   ```bash
   git clone https://github.com/davorg/psgi-systemd-deploy.git
   cd psgi-systemd-deploy

2. In your PSGI application directory, create a `.deploy.env` file with   
   environment-specific values. You can start with the provided example:

   ```bash
   cp example/.deploy.env.example /path/to/your/app/.deploy.env

3. Run the deployment script with the path to your app's `.deploy.env`:

   ```bash
   ./deploy.sh /path/to/your/app/.deploy.env

This will:

* Generate a `.service` file from the template
* Install it to `/etc/systemd/system`
* Reload `systemd` configuration
* Enable the service to start on boot
* Start the service immediately

## 📄 Files

* `webapp.service.template` – The generic systemd service unit file with
  placeholders
* `deploy.sh` – The deployment script that renders and installs the service
* `example/.deploy.env.example` – A sample environment file with placeholder
  values

## 🛠 Requirements

* `systemd` (Linux)
* `envsubst` (usually available via gettext)
* Your app should use a `.env` file and be launchable via Starman or similar

## 🧪 Example .deploy.env

    WEBAPP_NAME=My PSGI Web App
    WEBAPP_DESC=An example web application using PSGI and systemd
    WEBAPP_USER=www-data
    WEBAPP_GROUP=www-data
    WEBAPP_WORKDIR=/opt/myapp
    WEBAPP_ENVFILE=/opt/myapp/.env
    WEBAPP_LOGDIR=/var/log/myapp
    WEBAPP_SERVICE_NAME=myapp
    WEBAPP_CMD="/usr/bin/starman --workers=\${MYAPP_WORKERS:-2} -l :\${MYAPP_PORT:-5000} /opt/myapp/bin/app.psgi"

## 📚 License

MIT License

## 👤 Author

Created by Dave Cross (dave@davecross.co.uk), because `systemd` shouldn't be
scary and Perl shouldn't be left behind.
