# Use the official PHP + Apache image
FROM php:8.1-apache

# Copy application files to the Apache web root
COPY . /var/www/html/

# Expose port 80 for web traffic
EXPOSE 80

# Start Apache when the container runs
CMD ["apache2-foreground"]
