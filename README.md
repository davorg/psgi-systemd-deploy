# 📦 PSGI Systemd Deploy

A utility to streamline the deployment of PSGI applications using `systemd`.
This tool automates the creation and management of `systemd` service files
for your PSGI apps.

## 🔧 Features

- **Dynamic Service File Generation**: Automatically generates `systemd`
  service files using environment variables.
- **Customizable Deployment**: Configure service parameters via `.deploy.env`.
- **Dry-Run Mode**: Preview the generated service file without applying
  changes.
- **Flexible Runner Support**: Specify different PSGI runners (e.g., `starman`,
  `plackup`).
- **Environment Variable Expansion**: Supports dynamic values within `.env`
  files.

## 📄 Prerequisites

- A PSGI application with a `bin/app.psgi` entry point.
- `systemd` installed on the deployment server.
- Bash shell environment.

## 🚀 Quick Start

1. **Clone the Repository**:

   ```bash
   git clone https://github.com/davorg/psgi-systemd-deploy.git
   ```

2. **Prepare Your Application Directory**:

   Ensure your PSGI application resides in a directory with the following
   structure:

   ```
   your-app/
   ├── bin/
   │   └── app.psgi
   ├── .env
   └── .deploy.env
   ```

3. **Configure `.deploy.env`**:

   Create a `.deploy.env` file in your application directory with the necessary
   environment variables:

   ```ini
   WEBAPP_NAME=your_app_name
   WEBAPP_DESC="Your App Description"
   WEBAPP_USER=your_user
   WEBAPP_GROUP=your_group
   WEBAPP_WORKDIR=/path/to/your-app
   WEBAPP_ENVFILE=/path/to/your-app/.env
   WEBAPP_LOGDIR=/var/log/your-app
   WEBAPP_SERVICE_NAME=your-app
   WEBAPP_RUNNER=/usr/bin/starman
   WEBAPP_WORKER_COUNT=2
   WEBAPP_APP_PORT=5000
   WEBAPP_APP_PRELOAD=1
   ```

   *Note*: Adjust the values to match your application's requirements.

4. **Configure `.env`**:

   Define any runtime environment variables your application needs in the
   `.env` file:

   ```ini
   export SOME_ENV_VAR=some_value
   ```

5. **Deploy the Service**:

   Navigate to your application directory and run the deployment script:

   ```bash
   ../psgi-systemd-deploy/deploy.sh
   ```

   To perform a dry run and preview the generated service file:

   ```bash
   ../psgi-systemd-deploy/deploy.sh --dry-run
   ```

## 🛠️ Script Details

The `deploy.sh` script performs the following actions:

- Loads environment variables from `.deploy.env`.
- Constructs the `ExecStart` command dynamically based on provided variables.
- Generates a `systemd` service file using a template.
- Installs the service file to `/etc/systemd/system/`.
- Reloads the `systemd` daemon.
- Enables and restarts the service.

## 📝 Template Customization

The `webapp.service.template` file defines the structure of the generated
service file. It utilizes placeholders that are replaced with actual values
from `.deploy.env`. You can customize this template to suit specific
requirements.

## 📌 Notes

- Ensure that the user specified in `WEBAPP_USER` has the necessary permissions
  to run the application.
- The `WEBAPP_RUNNER` can be any PSGI-compatible server, such as `plackup` or
  `Twiggy`.
- Log files are directed to `WEBAPP_LOGDIR`. Ensure this directory exists and
  is writable by `WEBAPP_USER`.

## 🤝 Contributing

Contributions are welcome! Please fork the repository and submit a pull
request with your enhancements.

## 📄 License

This project is licensed under the MIT License.

## 👤 Author

Created by Dave Cross (dave@davecross.co.uk), because `systemd` shouldn't be
scary and Perl shouldn't be left behind.

