# ShellyScan Backup Service
## Overview

ShellyScan Backup Service is an open-source project designed to automatically backup the configuration of all compatible Shelly devices in your home network. This service utilizes [ShellyScanner](https://github.com/usnasoft/shellyscanner) [(Website)](https://github.com/usnasoft/shellyscanner) by usnasoft, a tool specifically designed for discovering and interacting with Shelly devices in your homenetwork.

The service operates within a Docker container and is configured to run backups every 7 days or at container startup, ensuring that your Shelly device configurations are regularly saved.

Warning:
Since the application communicates with the devices through the API exposed and documented by the manufacturer, it cannot damage them in any way.
About Backup/Restore of the devices configuration, it should be noted that not all parameters are restored; moreover is not guaranteed that the restore process does not alter parameters in an unforeseen way (I perform plenty of tests on my devices but the variants are probably many thousands). 

## Requirements

    Docker environment
    Network in 'host' mode to allow the container to communicate with Shelly devices on your home network

## Installation and Usage
### Docker Compose

Use the provided docker-compose.yml file to set up the service:

```yaml
version: '3'

services:
  shellyscan:
    build: .
    volumes:
      - data:/usr/src/myapp/
    environment:
      - INTERVAL=604800 # Default interval of 7 days in seconds
    network_mode: host
volumes:
  data:
```
### Dockerfile

The Dockerfile uses OpenJDK 17 as the base image and includes the necessary scripts to download ShellyScanner and execute the backup process.
Key Features:

-    Interval setting for backups (default 7 days)
-    Automatic download of ShellyScanner if not present
-    Creation of backup directories with timestamps

### Building the Docker Container

To build the Docker container, navigate to the directory containing the Dockerfile and run:

```bash
docker-compose build
```

### Running the Service

To start the service, use the following command:

```bash
docker-compose up -d
```

## How It Works

    The service automatically scans for Shelly devices in your network using ShellyScanner.
    It creates a backup of the configuration of each detected Shelly device.
    Backups are stored in timestamped directories within the Docker volume for easy access and management.

## Contributing

Contributions to the ShellyScan Backup Service are welcome. Please ensure to follow the standard coding practices and submit your pull requests for review.
## License

This project is open-source and free to use under the standard MIT license.