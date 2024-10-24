FROM nginx:latest

# Copy the setup nginx script
COPY setup-nginx.sh /setup-nginx.sh

# Make the script executable
RUN chmod +x /setup-nginx.sh

# Run the setup script and start Nginx
CMD ["/bin/bash", "-c", "/setup-nginx.sh && nginx -g 'daemon off;'"]