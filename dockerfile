# Use OpenJDK 17 as the base image
FROM openjdk:17

# Install cron
RUN apt-get update && apt-get install -y cron

# Add crontab file
RUN echo "0 0 * * 0 java -jar /usr/src/myapp/ShellyScan.jar /usr/src/myapp" > /etc/cron.d/shellyscan-cron

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/shellyscan-cron

# Apply cron job
RUN crontab /etc/cron.d/shellyscan-cron

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

# Create an entrypoint script
RUN echo "#!/bin/bash\n" \
            "echo Running\n" \
            "# Run the command on container startup\n" \
            "cron && tail -f /var/log/cron.log" > /entrypoint.sh

# Give execution rights on the entrypoint script
RUN chmod +x /entrypoint.sh

# Run the command on container startup
ENTRYPOINT ["/entrypoint.sh"]