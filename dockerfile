# Use OpenJDK 17 as the base image
FROM openjdk:17-buster

# Install necessary packages
RUN apt update && apt install -y wget nano && apt clean

# Create a directory for the application
RUN mkdir -p /usr/src/myapp

# Create an entrypoint script
RUN echo "#!/bin/bash\n" \
            "echo 'ShellyScan backup service starting...'\n" \
            "# Check if ShellyScan.jar exists, if not download it\n" \
            "if [ ! -f /usr/src/myapp/ShellyScan.jar ]; then\n" \
            "   wget -O /usr/src/myapp/ShellyScan.jar https://www.usna.it/shellyscanner/getfile.php?name=ShellyScan_1_0_2_sj.jar\n" \
            "fi\n" \
            "# Infinite loop for running backups\n" \
            "while true; do\n" \
            "   backup_dir=\"/usr/src/myapp/backup/\$(date +%Y%m%d_%H%M%S)\"\n" \
            "   echo \"Creating backup in \$backup_dir\"\n" \
            "   mkdir -p \$backup_dir\n" \
            "   java -jar /usr/src/myapp/ShellyScan.jar -backup \$backup_dir\n" \
            "   # Use environment variable for interval, default to 604800 seconds if not set\n" \
            "   echo 'Backup completed. Sleeping for ${INTERVAL:-604800} seconds...'\n" \
            "   sleep \${INTERVAL:-604800}\n" \
            "done" > /entrypoint.sh

# Give execution rights on the entrypoint script
RUN chmod +x /entrypoint.sh

# Run the command on container startup
ENTRYPOINT ["/entrypoint.sh"]