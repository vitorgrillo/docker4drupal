#!/bin/bash
set -e

supervisord -n -c /etc/supervisor/supervisord.conf

# Validate settings.php
FILE=/var/www/html/sites/default/settings.php
if [[ ! -f FILE ]]
then
  cp /var/www/html/sites/default/default.settings.php /var/www/html/sites/default/settings.php
fi

chmod 777 /var/www/html/sites/default/settings.php
chmod -R 777 /var/www/html/sites/default/files/

exec "$@"
