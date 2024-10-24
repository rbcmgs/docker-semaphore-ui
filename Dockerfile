FROM debian:stable-slim

# Install required packages including gosu
RUN apt-get update && \
  apt-get install -y wget python3 ansible git openssl postgresql-client gosu && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Download and install Semaphore
RUN wget https://github.com/ansible-semaphore/semaphore/releases/download/v2.10.32/semaphore_2.10.32_linux_amd64.deb && \
  dpkg -i semaphore_2.10.32_linux_amd64.deb && \
  rm semaphore_2.10.32_linux_amd64.deb

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh

# Ensure the script is executable
RUN chmod +x /entrypoint.sh

# Expose port for Semaphore UI
EXPOSE 3000

# Set entrypoint to the custom script
ENTRYPOINT ["/entrypoint.sh"]